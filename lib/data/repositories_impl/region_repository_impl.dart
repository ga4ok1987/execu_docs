import 'package:drift/drift.dart';
import 'package:execu_docs/data/datasources/local/database.dart';
import 'package:execu_docs/data/mappers/region_dto_mapper.dart';
import 'package:execu_docs/domain/entities/region_entity.dart';
import 'package:execu_docs/domain/repositories/region_repository.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/executor_office_entity.dart';
import '../datasources/local/region_dao.dart';
@LazySingleton(as: RegionRepository)
class RegionRepositoryImpl implements RegionRepository {
  final RegionDao _regionDao;

  RegionRepositoryImpl(this._regionDao);

  @override
  Future<List<RegionEntity>> getAllRegions() async {
    return await _regionDao.getAllRegionsWithOffices();
  }

  @override
  Future<void> addRegion(RegionEntity entity) async {
    final companion = RegionsCompanion(name: Value(entity.name));
    await _regionDao.insertRegion(companion);
  }

  @override
  Future<void> deleteRegion(int id) async {
    await _regionDao.deleteById(id);
  }

  @override
  Future<void> updateRegionName(int regionId, String newName) async {
    await _regionDao.updateRegionName(regionId, newName);
  }

  @override
  Future<void> updateExecutorOffices(
    int regionId,
    List<ExecutorOfficeEntity> offices,
  ) async {
    await _regionDao.updateExecutorOffices(regionId, offices);
  }

  @override
  Future<void> seedRegions(List<String> regionNames) async {
    final isEmpty = await _regionDao.isEmpty();
    if (isEmpty) {
      for (final name in regionNames) {
        await _regionDao.insertRegion(RegionsCompanion(name: Value(name)));
      }
    }
  }

  // @override
  // Future<void> addExecutorOffice(int regionId, String name) async {
  //   await _officeDao.insertRegion(
  //     ExecutorOfficesCompanion(regionId: Value(regionId), name: Value(name)),
  //   );
  // }
  //
  // @override
  // Future<void> deleteExecutorOffice(int id) async {
  //   await _officeDao.deleteById(id);
  // }


}
