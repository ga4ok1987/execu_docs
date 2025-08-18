import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/executor_entity.dart';
import '../../domain/usecases/executors_crud_usecases.dart';

@injectable
class ExecutorCubit extends Cubit<ExecutorState> {
  final AddExecutorUseCase addExecutorUseCase;
  final UpdateExecutorUseCase updateExecutorUseCase;
  final DelExecutorUseCase delExecutorUseCase;
  final GetExecutorsByRegionIdUseCase getExecutorsByRegionIdUseCase;

  final int regionId;

  ExecutorCubit(
    @factoryParam this.regionId,
     this.addExecutorUseCase,
     this.updateExecutorUseCase,
     this.delExecutorUseCase,
     this.getExecutorsByRegionIdUseCase,
  ) : super(ExecutorInitial()) {
    loadOffices(regionId);
    }

  Future<void> loadOffices(int id) async {
    emit(ExecutorLoading());

    final result = await getExecutorsByRegionIdUseCase(regionId);

    result.fold(
      (failure) => emit(ExecutorError(failure.message)),
      (executors) => emit(ExecutorLoaded(executors)),
    );
  }

  Future<void> addOffice(ExecutorEntity office) async {
    emit(ExecutorLoading());

    final result = await addExecutorUseCase(office);

    result.fold(
      (failure) => emit(ExecutorError(failure.message)),
      (_) => loadOffices(office.regionId),
    );
  }

  Future<void> editOffice(ExecutorEntity updatedOffice) async {
    emit(ExecutorLoading());

    final result = await updateExecutorUseCase(updatedOffice);

    result.fold(
          (failure) => emit(ExecutorError(failure.message)),
          (_) => loadOffices(updatedOffice.regionId),
    );
  }

  Future<void> removeOffice(ExecutorEntity entity) async {
    emit(ExecutorLoading());

    final result = await delExecutorUseCase(entity.id);

    result.fold(
          (failure) => emit(ExecutorError(failure.message)),
          (_) => loadOffices(entity.regionId),
    );
  }
}

sealed class ExecutorState {}

class ExecutorInitial extends ExecutorState {}

class ExecutorLoading extends ExecutorState {}

class ExecutorLoaded extends ExecutorState {
  final List<ExecutorEntity> offices;

  ExecutorLoaded(this.offices);
}

class ExecutorError extends ExecutorState {
  final String message;

  ExecutorError(this.message);
}
