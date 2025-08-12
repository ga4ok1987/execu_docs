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
    final prevRegions = state is RegionLoaded
        ? (state as RegionLoaded).regions
        : <RegionEntity>[];
    emit(RegionLoading());
    final result = await getAllRegionsUseCase();
    result.fold(
          (failure) {
        emit(RegionError(failure.message, prevRegions));
      },
          (regions) {
        regions.sort((a,b) => a.name.compareTo(b.name));
        emit(RegionLoaded(regions));
      },
    );
  }

  Future<void> addRegion(RegionEntity region) async {
    final prevRegions = state is RegionLoaded
        ? (state as RegionLoaded).regions
        : <RegionEntity>[];
    emit(RegionLoading());
    final res = await addRegionUseCase(region);
    res.fold(
          (failure) {
        emit(RegionError(failure.message, prevRegions));
      },
          (_) async {
        await loadRegions();
      },
    );
  }

  Future<void> removeRegion(int id) async {
    final prevRegions = state is RegionLoaded
        ? (state as RegionLoaded).regions
        : <RegionEntity>[];
    emit(RegionLoading());
    final res = await deleteRegionUseCase(id);
    res.fold(
          (failure) {
        emit(RegionError(failure.message, prevRegions));
      },
          (_) async {
        await loadRegions();
      },
    );
  }

  Future<void> updateRegionName(int id, String newName) async {
    final prevRegions = state is RegionLoaded
        ? (state as RegionLoaded).regions
        : <RegionEntity>[];

    emit(RegionLoading());

    final res = await updateRegionNameUseCase(id, newName);
    res.fold(
          (failure) => emit(RegionError(failure.message, prevRegions)),
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
  final List<RegionEntity> previousRegions; // щоб не втрачати список
  RegionError(this.message, [this.previousRegions = const []]);
}
