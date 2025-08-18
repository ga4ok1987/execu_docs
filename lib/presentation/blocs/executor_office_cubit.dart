import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/executor_office_entity.dart';
import '../../domain/usecases/executors_crud_usecases.dart';
import '../../domain/usecases/get_region_by_id_usecase.dart';
import '../../domain/usecases/update_region_usecase.dart';

@injectable
class ExecutorOfficeCubit extends Cubit<ExecutorOfficeState> {
  final AddExecutorUseCase addExecutorUseCase;
  final UpdateExecutorUseCase updateExecutorUseCase;
  final DelExecutorUseCase delExecutorUseCase;
  final GetExecutorsByRegionIdUseCase getExecutorsByRegionIdUseCase;

  int? regionId;

  ExecutorOfficeCubit({
    this.regionId,
    required this.addExecutorUseCase,
    required this.updateExecutorUseCase,
    required this.delExecutorUseCase,
    required this.getExecutorsByRegionIdUseCase,
  }) : super(ExecutorOfficeInitial()) {
    if (regionId != null) {
      loadOffices(regionId!);
    }
  }



  Future<void> loadOffices(int id) async {

    emit(ExecutorOfficeLoading());

    final result = await getExecutorsByRegionIdUseCase(regionId!);

    result.fold(
      (failure) => emit(ExecutorOfficeError(failure.message)),
      (executors) => emit(ExecutorOfficeLoaded(executors)),
    );
  }

  Future<void> addOffice(ExecutorOfficeEntity office) async {
    emit(ExecutorOfficeLoading());

    final result = await addExecutorUseCase(office);

    result.fold(
      (failure) => emit(ExecutorOfficeError(failure.message)),
      (_) => loadOffices(office.regionId),
    );
  }

  Future<void> editOffice(ExecutorOfficeEntity updatedOffice) async {
    if (regionId == null) {
      emit(ExecutorOfficeError("Region ID не встановлений"));
      return;
    }

    emit(ExecutorOfficeLoading());

    final result = await updateExecutorUseCase(updatedOffice);

    result.fold((failure) => emit(ExecutorOfficeError(failure.message)), (
      region,
    ) {
      (_) => loadOffices(updatedOffice.regionId);
    });
  }

  Future<void> removeOffice(ExecutorOfficeEntity entity) async {

    emit(ExecutorOfficeLoading());

    final regionResult = await delExecutorUseCase(regionId!);

     regionResult.fold(
      (failure)  => emit(ExecutorOfficeError(failure.message)),
      (region)  {
        (_)  =>  loadOffices(entity.regionId);
      },
    );
  }
}

sealed class ExecutorOfficeState {}

class ExecutorOfficeInitial extends ExecutorOfficeState {}

class ExecutorOfficeLoading extends ExecutorOfficeState {}

class ExecutorOfficeLoaded extends ExecutorOfficeState {
  final List<ExecutorOfficeEntity> offices;

  ExecutorOfficeLoaded(this.offices);
}

class ExecutorOfficeError extends ExecutorOfficeState {
  final String message;

  ExecutorOfficeError(this.message);
}
