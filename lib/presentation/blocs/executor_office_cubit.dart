import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/executor_office_entity.dart';
import '../../domain/usecases/get_region_by_id_usecase.dart';
import '../../domain/usecases/update_region_usecase.dart';

@injectable
class ExecutorOfficeCubit extends Cubit<ExecutorOfficeState> {
  final GetRegionByIdUseCase getRegionById;
  final UpdateRegionUseCase updateRegion;

  int? regionId;

  ExecutorOfficeCubit({
    this.regionId,
    required this.getRegionById,
    required this.updateRegion,
  }) : super(ExecutorOfficeInitial()) {
    if (regionId != null) {
      loadOffices();
    }
  }

  Future<void> setRegionId(int newRegionId) async {
    regionId = newRegionId;
    await loadOffices();
  }

  Future<void> loadOffices() async {
    if (regionId == null) {
      emit(ExecutorOfficeError("Region ID не встановлений"));
      return;
    }

    emit(ExecutorOfficeLoading());

    final result = await getRegionById(regionId!);

    result.fold(
          (failure) => emit(ExecutorOfficeError(failure.message)),
          (region) => emit(ExecutorOfficeLoaded(List.from(region.executorOffices))),
    );
  }

  Future<void> addOffice(ExecutorOfficeEntity office) async {
    if (regionId == null) {
      emit(ExecutorOfficeError("Region ID не встановлений"));
      return;
    }

    emit(ExecutorOfficeLoading());

    final regionResult = await getRegionById(regionId!);

    await regionResult.fold(
          (failure) async => emit(ExecutorOfficeError(failure.message)),
          (region) async {
        final updatedRegion = region.copyWith(
          executorOffices: [...region.executorOffices, office],
        );
        final updateResult = await updateRegion(updatedRegion);

        updateResult.fold(
              (failure) => emit(ExecutorOfficeError(failure.message)),
              (_) async => await loadOffices(),
        );
      },
    );
  }

  Future<void> editOffice(ExecutorOfficeEntity updatedOffice) async {
    if (regionId == null) {
      emit(ExecutorOfficeError("Region ID не встановлений"));
      return;
    }

    emit(ExecutorOfficeLoading());

    final regionResult = await getRegionById(regionId!);

    await regionResult.fold(
          (failure) async => emit(ExecutorOfficeError(failure.message)),
          (region) async {
        final updatedOffices = region.executorOffices
            .map((o) => o.id == updatedOffice.id ? updatedOffice : o)
            .toList();

        final updatedRegion = region.copyWith(executorOffices: updatedOffices);

        final updateResult = await updateRegion(updatedRegion);

        updateResult.fold(
              (failure) => emit(ExecutorOfficeError(failure.message)),
              (_) async => await loadOffices(),
        );
      },
    );
  }

  Future<void> removeOffice(int officeId) async {
    if (regionId == null) {
      emit(ExecutorOfficeError("Region ID не встановлений"));
      return;
    }

    emit(ExecutorOfficeLoading());

    final regionResult = await getRegionById(regionId!);

    await regionResult.fold(
          (failure) async => emit(ExecutorOfficeError(failure.message)),
          (region) async {
        final updatedOffices =
        region.executorOffices.where((o) => o.id != officeId).toList();

        final updatedRegion = region.copyWith(executorOffices: updatedOffices);

        final updateResult = await updateRegion(updatedRegion);

        updateResult.fold(
              (failure) => emit(ExecutorOfficeError(failure.message)),
              (_) async => await loadOffices(),
        );
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
