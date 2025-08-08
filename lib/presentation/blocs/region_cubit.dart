import 'package:execu_docs/domain/entities/region_entity.dart';
import 'package:execu_docs/domain/usecases/add_region_usacase.dart';
import 'package:execu_docs/domain/usecases/update_region_name_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usecases/del_region_usecase.dart';
import '../../domain/usecases/get_all_region_usecase.dart';
@injectable
class RegionCubit extends Cubit<List<RegionEntity>> {
  final GetAllRegionsUseCase getAllRegionsUseCase;
  final DelRegionUseCase deleteRegionUseCase;
  final AddRegionUseCase addRegionUseCase;
  final UpdateRegionNameUseCase updateRegionNameUseCase;

  RegionCubit({
    required this.getAllRegionsUseCase,
    required this.deleteRegionUseCase,
    required this.addRegionUseCase,
    required this.updateRegionNameUseCase,
  }) : super([]);

  Future<void> loadRegions() async {
    final result = await getAllRegionsUseCase();
    result.sort((a,b) => a.name.compareTo(b.name));
    emit(result);
  }

  Future<void> removeRegion(int id) async {
    await deleteRegionUseCase(id);
    await loadRegions();
  }

  Future<void> addRegion(RegionEntity region) async {
    await addRegionUseCase(region);
    await loadRegions();
  }
Future<void> updateRegionName(int id, region) async {
    await updateRegionNameUseCase(id,region);
    await loadRegions();
  }

}

