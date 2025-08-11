import 'package:execu_docs/domain/entities/region_entity.dart';
import 'package:execu_docs/domain/usecases/add_region_usacase.dart';
import 'package:execu_docs/domain/usecases/update_region_name_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usecases/del_region_usecase.dart';
import '../../domain/usecases/get_all_region_usecase.dart';
@injectable
class RegionCubit extends Cubit<RegionState> {
  final GetAllRegionsUseCase getAllRegionsUseCase;
  final DelRegionUseCase deleteRegionUseCase;
  final AddRegionUseCase addRegionUseCase;
  final UpdateRegionNameUseCase updateRegionNameUseCase;

  RegionCubit({
    required this.getAllRegionsUseCase,
    required this.deleteRegionUseCase,
    required this.addRegionUseCase,
    required this.updateRegionNameUseCase,
  }) : super(RegionInitial());

  Future<void> loadRegions() async {
    emit(RegionLoading());
    final result = await getAllRegionsUseCase();
    result.fold(
            (failure) => emit(RegionError(failure.message)),
            (regions) {
          regions.sort((a, b) => a.name.compareTo(b.name));
          emit(RegionLoaded(regions));
        }
    );
  }

  Future<void> removeRegion(int id) async {
    final result = await deleteRegionUseCase(id);
    result.fold(
          (failure) => emit(RegionError(failure.message)),
          (_) async => await loadRegions(),
    );
  }

  Future<void> addRegion(RegionEntity region) async {
    emit(RegionLoading());
    final result = await addRegionUseCase(region);
    result.fold(
          (failure) => emit(RegionError(failure.message)),
          (_) async => await loadRegions(),
    );
  }

  Future<void> updateRegionName(int id, String newName) async {
    emit(RegionLoading());
    final result = await updateRegionNameUseCase(id, newName);
    result.fold(
          (failure)  => emit(RegionError(failure.message)),
          (_) async => await loadRegions(),
    );
  }


}

sealed class RegionState {}

class RegionInitial extends RegionState {}
class RegionLoading extends RegionState {}
class RegionLoaded extends RegionState {
  final List<RegionEntity> regions;
  RegionLoaded(this.regions);
}
class RegionError extends RegionState {
  final String message;
  RegionError(this.message);
}
