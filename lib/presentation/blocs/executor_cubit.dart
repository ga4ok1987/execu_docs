import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/executor_office_entity.dart';

class ExecutorOfficeCubit extends Cubit<List<ExecutorOfficeEntity>> {
  final GetRegionByIdUseCase getRegionById;
  final UpdateRegionUseCase updateRegion;

  final int regionId;

  ExecutorOfficeCubit({
    required this.regionId,
    required this.getRegionById,
    required this.updateRegion,
  }) : super([]) {
    _loadOffices();
  }

  void _loadOffices() {
    final region = getRegionById(regionId);
    emit(List.from(region.executorOffices));
  }

  Future<void> addOffice(ExecutorOfficeEntity office) async {
    final region = getRegionById(regionId);
    final updatedRegion = region.copyWith(
      executorOffices: [...region.executorOffices, office],
    );
    await updateRegion(updatedRegion);
    _loadOffices();
  }

  Future<void> editOffice(ExecutorOfficeEntity updatedOffice) async {
    final region = getRegionById(regionId);
    final updatedOffices = region.executorOffices
        .map((o) => o.id == updatedOffice.id ? updatedOffice : o)
        .toList();
    final updatedRegion = region.copyWith(executorOffices: updatedOffices);
    await updateRegion(updatedRegion);
    _loadOffices();
  }

  Future<void> removeOffice(int officeId) async {
    final region = getRegionById(regionId);
    final updatedOffices =
        region.executorOffices.where((o) => o.id != officeId).toList();
    final updatedRegion = region.copyWith(executorOffices: updatedOffices);
    await updateRegion(updatedRegion);
    _loadOffices();
  }
}
