import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/executor_office_entity.dart';
import '../../domain/usecases/get_region_by_id_usecase.dart';
import '../../domain/usecases/update_region_usecase.dart';

@injectable
class ExecutorOfficeCubit extends Cubit<List<ExecutorOfficeEntity>> {
  final GetRegionByIdUseCase getRegionById;
  final UpdateRegionUseCase updateRegion;

   int? regionId;
  ExecutorOfficeCubit({
    this.regionId,
    required this.getRegionById,
    required this.updateRegion,
  }) : super([]) {
    _loadOffices();
  }

  Future<void> setRegionId(int regionId) async {
    regionId = regionId;
    await _loadOffices();
  }

  Future<void> _loadOffices() async {
    final region = await getRegionById(regionId!);
    emit(List.from(region.executorOffices));
  }

  Future<void> addOffice(ExecutorOfficeEntity office) async {
    final region = await getRegionById(regionId!);
    final updatedRegion = region.copyWith(
      executorOffices: [...region.executorOffices, office],
    );
    await updateRegion(updatedRegion);
    await _loadOffices();
  }

  Future<void> editOffice(ExecutorOfficeEntity updatedOffice) async {
    final region = await getRegionById(regionId!);
    final updatedOffices = region.executorOffices
        .map((o) => o.id == updatedOffice.id ? updatedOffice : o)
        .toList();
    final updatedRegion = region.copyWith(executorOffices: updatedOffices);
    await updateRegion(updatedRegion);
    await _loadOffices();
  }

  Future<void> removeOffice(int officeId) async {
    final region = await getRegionById(regionId!);
    final updatedOffices =
    region.executorOffices.where((o) => o.id != officeId).toList();
    final updatedRegion = region.copyWith(executorOffices: updatedOffices);
    await updateRegion(updatedRegion);
    await _loadOffices();
  }
}