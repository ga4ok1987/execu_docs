import 'dart:async';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:execu_docs/core/utils/extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import '../../core/utils/docx_reader.dart';
import '../../core/utils/generate_docx.dart';
import '../../core/utils/word_merger.dart';
import '../../domain/entities/debtor_entity.dart';
import '../../domain/entities/region_entity.dart';
import '../../domain/usecases/debtors_crud_usecases.dart';
import '../../domain/usecases/regions_crud_usecase.dart';
import '../../core/failure.dart';
import 'package:equatable/equatable.dart';
import 'package:execu_docs/core/constants/index.dart';

@injectable
class DebtorCubit extends Cubit<DebtorState> {
  final AddDebtorUseCase addDebtorUseCase;
  final UpdateDebtorUseCase updateDebtorUseCase;
  final DeleteDebtorUseCase deleteDebtorUseCase;
  final GetDebtorsUseCase getDebtorsUseCase;
  final GetAllRegionsUseCase getAllRegionsUseCase;
  final ClearDebtorsUseCase clearDebtorsUseCase;

  DebtorCubit({
    required this.addDebtorUseCase,
    required this.updateDebtorUseCase,
    required this.deleteDebtorUseCase,
    required this.getDebtorsUseCase,
    required this.getAllRegionsUseCase,
    required this.clearDebtorsUseCase,
  }) : super(DebtorInitial());

  StreamSubscription<double>? _mergeSubscription;

  @override
  Future<void> close() {
    _mergeSubscription?.cancel();
    return super.close();
  }

  Future<void> loadDebtors() async {
    emit(DebtorLoading());
    final Either<Failure, List<DebtorEntity>> result =
        await getDebtorsUseCase();
    result.fold(
      (failure) => emit(DebtorError(failure.message)),
      (debtors) => emit(DebtorLoaded(debtors)),
    );
  }

  Future<void> updateDebtor(DebtorEntity debtor) async {
    final Either<Failure, Unit> result = await updateDebtorUseCase(debtor);
    result.fold(
      (failure) => emit(DebtorError(failure.message)),
      (_) => loadDebtors(),
    );
  }

  Future<void> addDebtor(DebtorEntity debtor) async {
    final Either<Failure, Unit> result = await addDebtorUseCase(debtor);
    result.fold(
      (failure) => emit(DebtorError(failure.message)),
      (_) => loadDebtors(),
    );
  }

  Future<void> _addDebtorSilently(DebtorEntity debtor) async {
    final result = await addDebtorUseCase(debtor);
    result.fold((f) => emit(DebtorError(f.message)), (_) {});
  }

  Future<void> deleteDebtor(int id) async {
    final Either<Failure, Unit> result = await deleteDebtorUseCase(id);
    result.fold(
      (failure) => emit(DebtorError(failure.message)),
      (_) => loadDebtors(),
    );
  }

  Future<void> clearDebtors() async {
    final Either<Failure, Unit> result = await clearDebtorsUseCase();
    result.fold(
      (failure) => emit(DebtorError(failure.message)),
      (_) => loadDebtors(),
    );
  }

  Future<void> exportDebtors(String path) async {
    List<RegionEntity>? regions;
    List<DebtorEntity>? debtors;
    final Either<Failure, List<RegionEntity>> result =
        await getAllRegionsUseCase();
    result.fold(
      (failure) => regions = null,
      (loadedRegions) => regions = loadedRegions,
    );
    final Either<Failure, List<DebtorEntity>> resultDebtors =
        await getDebtorsUseCase();
    resultDebtors.fold(
      (failure) => null,
      (loadedDebtors) => debtors = loadedDebtors,
    );
    try {
      final generator = DebtorDocxGenerator(regions ?? []);

      final total = debtors?.length;
      int done = 0;
      for (final debtor in debtors!) {
        await generator.generateDebtorsDoc(debtor, path);
        done++;
        emit(DebtorLoaded(debtors!, progress: (done / total!) * 0.5));
      }
       generator.generateTernopilDebtorsListDoc(debtors ?? [], path);
      _mergeSubscription?.cancel();
      _mergeSubscription =
          WordMerger.mergeDocsWithProgress(
            '$path/${AppTexts.coverDocs}',
            AppAssets.emptyTemplate,
            false,
          ).listen(
            (mergeProgress) {
              // додаємо до прогресу генерації, діапазон 0.5..1.0
              final overall = 0.5 + mergeProgress * 0.5;
              emit(DebtorLoaded(progress: overall, debtors!));
            },
            onError: (e) {
              emit(DebtorError(e.toString()));
            },
            onDone: () {
              emit(DebtorLoaded(debtors!));
            },
          );
    } catch (e) {
      emit(DebtorError(e.toString()));
    }
  }

  Future<void> uniteFiles(String path) async {
    List<DebtorEntity>? debtors;
    final Either<Failure, List<DebtorEntity>> resultDebtors =
        await getDebtorsUseCase();
    resultDebtors.fold(
      (failure) => null,
      (loadedDebtors) => debtors = loadedDebtors,
    );
    try {
      _mergeSubscription?.cancel();
      _mergeSubscription =
          WordMerger.mergeDocsWithProgress(
            path,
            AppAssets.emptyResolutionTemplate,
            true,
          ).listen(
            (mergeProgress) {
              emit(DebtorLoaded(progress: mergeProgress, debtors!));
            },
            onError: (e) {
              emit(DebtorError(e.toString()));
            },
            onDone: () {
              emit(DebtorLoaded(debtors!));
            },
          );
    } catch (e) {
      emit(DebtorError(e.toString()));
    }
  }

  Future<void> importFromDocx(String dirPath) async {
    if (state is! DebtorLoaded) {
      emit(DebtorLoading());
      await loadDebtors(); // щоб завжди був список
    }
    final current = state is DebtorLoaded
        ? (state as DebtorLoaded).debtors
        : [];
    List<RegionEntity>? regions;
    final Either<Failure, List<RegionEntity>> result =
        await getAllRegionsUseCase();
    result.fold(
      (failure) => regions = null,
      (loadedRegions) => regions = loadedRegions,
    );

    final directory = Directory(dirPath);
    final files = directory
        .listSync()
        .where((f) => f.path.endsWith('.docx'))
        .toList();

    if (files.isEmpty) {
      emit(DebtorError("Не знайдено DOCX файлів"));
      return;
    }

    for (int i = 0; i < files.length; i++) {
      final text = await DocxReader().readDocxParagraphs(files[i].path);

      final fullName = text[15].extractName;
      final decree = text[2].extractDecree;
      final address = text[8].extractAddress;
      final amount = text[15].extractAmount;
      final regionId = address.extractRegion(regions);
      final executorsList = (regionId != null)
          ? regions
                ?.firstWhere((element) => element.id == regionId)
                .executorOffices
          : [];
      final executorId = executorsList
          ?.firstWhereOrNull((element) => element.isPrimary)
          ?.id;

      final debtor = DebtorEntity(
        id: 0,
        fullName: fullName,
        decree: decree,
        amount: amount,
        address: address,
        regionId: regionId,
        executorId: executorId,
      );
      current.add(debtor);
      await _addDebtorSilently(debtor);
      final progress = (i + 1) / files.length;
      await Future.delayed(Duration(milliseconds: 100));
      emit(DebtorLoaded(current as List<DebtorEntity>, progress: progress));
    }

    await loadDebtors();
  }

  // Якщо треба оновити локальний стан без перезавантаження з бази:
  void updateAfterDeletion({int? deletedRegionId, int? deletedExecutorId}) {
    if (state is! DebtorLoaded) return;
    final currentDebtors = (state as DebtorLoaded).debtors;

    final updatedDebtors = currentDebtors.map((debtor) {
      var newRegionId = debtor.regionId;
      var newExecutorId = debtor.executorId;

      if (deletedRegionId != null && debtor.regionId == deletedRegionId) {
        newRegionId = null;
        newExecutorId = null;
      }

      if (deletedExecutorId != null && debtor.executorId == deletedExecutorId) {
        newExecutorId = null;
      }

      if (newRegionId != debtor.regionId ||
          newExecutorId != debtor.executorId) {
        return debtor.copyWith(
          regionId: newRegionId,
          executorId: newExecutorId,
        );
      } else {
        return debtor;
      }
    }).toList();

    emit(DebtorLoaded(updatedDebtors));
  }
}

sealed class DebtorState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DebtorInitial extends DebtorState {}

class DebtorLoading extends DebtorState {}

class DebtorLoaded extends DebtorState {
  final List<DebtorEntity> debtors;
  final double? progress; // null коли імпорту нема

  DebtorLoaded(this.debtors, {this.progress});

  DebtorLoaded copyWith({List<DebtorEntity>? debtors, double? progress}) {
    return DebtorLoaded(
      debtors ?? this.debtors,
      progress: progress ?? this.progress,
    );
  }

  @override
  List<Object?> get props => [debtors, progress];
}

class DebtorError extends DebtorState {
  final String message;

  DebtorError(this.message);

  @override
  List<Object?> get props => [message];
}
