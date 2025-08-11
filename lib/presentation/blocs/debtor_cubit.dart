import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';

import '../../domain/entities/debtor_entity.dart';
import '../../domain/usecases/add_debtor_usecase.dart';
import '../../domain/usecases/delete_debtor_usecase.dart';
import '../../domain/usecases/get_debtors_usecase.dart';
import '../../domain/usecases/update_debtor_usecase.dart';
import '../../core/failure.dart';

@injectable
class DebtorCubit extends Cubit<DebtorState> {
  final AddDebtorUseCase addDebtorUseCase;
  final UpdateDebtorUseCase updateDebtorUseCase;
  final DeleteDebtorUseCase deleteDebtorUseCase;
  final GetDebtorsUseCase getDebtorsUseCase;

  DebtorCubit({
    required this.addDebtorUseCase,
    required this.updateDebtorUseCase,
    required this.deleteDebtorUseCase,
    required this.getDebtorsUseCase,
  }) : super(DebtorInitial());

  Future<void> loadDebtors() async {
    emit(DebtorLoading());
    final Either<Failure, List<DebtorEntity>> result = await getDebtorsUseCase();
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

      if (newRegionId != debtor.regionId || newExecutorId != debtor.executorId) {
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

class DebtorLoaded extends DebtorState {
  final List<DebtorEntity> debtors;
  DebtorLoaded(this.debtors);
}

class DebtorError extends DebtorState {
  final String message;
  DebtorError(this.message);
}
