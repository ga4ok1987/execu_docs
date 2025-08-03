import 'package:execu_docs/domain/entities/region_entity.dart';
import 'package:execu_docs/domain/usecases/add_region_usacase.dart';
import 'package:execu_docs/domain/usecases/update_region_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/del_region_usecase.dart';
import '../../domain/usecases/get_all_region_usecase.dart';

class RegionCubit extends Cubit<List<RegionEntity>> {
  final GetAllRegionsUseCase getAllRegionsUseCase;
  final DelRegionUseCase deleteRegionUseCase;
  final AddRegionUseCase addRegionUseCase;
  final UpdateRegionUseCase updateRegionUseCase;

  RegionCubit({
    required this.getAllRegionsUseCase,
    required this.deleteRegionUseCase,
    required this.addRegionUseCase,
    required this.updateRegionUseCase,
  }) : super([]);

  Future<void> loadRegions() async {
    emit(await getAllRegionsUseCase());
  }

  Future<void> removeRegion(int id) async {
    await deleteRegionUseCase(id);
    await loadRegions();
  }

  Future<void> addRegion(RegionEntity region) async {
    await addRegionUseCase(region);
    await loadRegions();
  }

  Future<void> upDateRegion(RegionEntity region) async {
    await updateRegionUseCase(region);
    await loadRegions();
  }
}

