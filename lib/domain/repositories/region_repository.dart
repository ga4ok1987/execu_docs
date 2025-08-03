import 'package:execu_docs/domain/entities/region_entity.dart';

abstract class RegionRepository {
  Future<List<RegionEntity>> getAllRegions();
  Future<void> addRegion(RegionEntity region);
  Future<void> deleteRegion(int id);
  Future<void> updateRegion(RegionEntity region);
  Future<void> updateRegionName(int regionId, String newName);

}