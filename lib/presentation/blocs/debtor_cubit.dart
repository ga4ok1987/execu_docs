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
    emit(DebtorLoading());
    final Either<Failure, Unit> result = await updateDebtorUseCase(debtor);
    result.fold(
      (failure) => emit(DebtorError(failure.message)),
      (_) => loadDebtors(),
    );
  }

  Future<void> addDebtor(DebtorEntity debtor) async {
    emit(DebtorLoading());
    final Either<Failure, Unit> result = await addDebtorUseCase(debtor);
    result.fold(
      (failure) => emit(DebtorError(failure.message)),
      (_) => loadDebtors(),
    );
  }

  Future<void> deleteDebtor(int id) async {
    emit(DebtorLoading());
    final Either<Failure, Unit> result = await deleteDebtorUseCase(id);
    result.fold(
      (failure) => emit(DebtorError(failure.message)),
      (_) => loadDebtors(),
    );
  }

  Future<void> clearDebtors() async {
    emit(DebtorLoading());
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
    resultDebtors.fold((failure)=>null,
        (loadedDebtors) => debtors = loadedDebtors);
    final generator = DebtorDocxGenerator(regions??[]);
    await generator.generateDebtorsDoc(debtors!,path);
    await WordMerger.mergeDocs(path);


  }

  Future<void> importFromDocx(String dirPath) async {
    emit(DebtorLoading());
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


    for (var file in files) {
      final text = await DocxReader().readDocxParagraphs(file.path);

      final fullName = text[15].extractName;
      final decree = text[2].extractDecree;
      final address = text[8].extractAddress;
      final amount = text[15].extractAmount;
      final regionId = address.extractRegion(regions);
      final executorsList = (regionId != null)
          ? regions
          ?.firstWhere((element) => element.id == regionId)
          .executorOffices:[];
      final executorId = executorsList?.firstWhereOrNull(
        (element) => element.isPrimary,
      )?.id;

      final debtor = DebtorEntity(
        id: 0,
        fullName: fullName,
        decree: decree,
        amount: amount,
        address: address,
        regionId: regionId,
        executorId: executorId,
      );
      await addDebtor(debtor);
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

sealed class DebtorState {}

class DebtorInitial extends DebtorState {}

class DebtorLoading extends DebtorState {}

class DebtorImporting extends DebtorState {
  final double progress;

  DebtorImporting(this.progress);
}

class DebtorLoaded extends DebtorState {
  final List<DebtorEntity> debtors;

  DebtorLoaded(this.debtors);
}

class DebtorError extends DebtorState {
  final String message;

  DebtorError(this.message);
}
