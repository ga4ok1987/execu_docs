import 'package:execu_docs/domain/entities/region_entity.dart';

import '../entities/executor_office_entity.dart';

abstract class RegionRepository {
  Future<List<RegionEntity>> getAllRegions();
  Future<void> addRegion(RegionEntity region);
  Future<void> deleteRegion(int id);
  Future<void> updateRegionName(int regionId, String newName);
  Future<void> updateExecutorOffices(int regionId,
      List<ExecutorOfficeEntity> offices);
  Future<void> seedRegions(List<String> regionNames);
}