import 'package:drift/drift.dart';
import 'package:execu_docs/data/mappers/executor_office_dto_mapper.dart';
import 'package:execu_docs/data/mappers/region_dto_mapper.dart';
import '../local/database.dart';
import '../../../domain/entities/region_entity.dart';
import '../../../domain/entities/executor_office_entity.dart';


part 'region_dao.g.dart';

@DriftAccessor(tables: [Regions, ExecutorOffices])
class RegionDao extends DatabaseAccessor<AppDatabase> with _$RegionDaoMixin {
  RegionDao(super.db);

  Future<List<RegionEntity>> getAllRegionsWithOffices() async {
    final query = select(regions).join([
      leftOuterJoin(
        executorOffices,
        executorOffices.regionId.equalsExp(regions.id),
      ),
    ]);

    final rows = await query.get();

    final Map<int, RegionDto> regionMap = {};
    final Map<int, List<ExecutorOfficeEntity>> officeMap = {};

    for (final row in rows) {
      final region = row.readTable(regions);
      final office = row.readTableOrNull(executorOffices);

      regionMap[region.id] = region;
      if (office != null) {
        officeMap.putIfAbsent(region.id, () => []).add(office.toEntity());
      }
    }

    return regionMap.entries
        .map((e) => e.value.toEntity(officeMap[e.key] ?? []))
        .toList();
  }

  Future<int> insertRegion(Insertable<RegionDto> region) => into(regions).insert(region);


  Future<void> deleteById(int regionId) async {

    await (delete(executorOffices)..where((e) => e.regionId.equals(regionId))).go();
  }

  Future<void> updateRegionName(int regionId, String newName) async {
    await (update(regions)..where((r) => r.id.equals(regionId)))
        .write(RegionsCompanion(name: Value(newName)));
  }

  Future<void> updateExecutorOffices(int regionId, List<ExecutorOfficeEntity> newOffices) async {
    await transaction(() async {
      final existingOffices = await (select(executorOffices)
        ..where((o) => o.regionId.equals(regionId)))
          .get();

      final idsToKeep = newOffices.where((o) => o.id != 0).map((e) => e.id).toSet();
      final idsToDelete =
      existingOffices.map((e) => e.id).where((id) => !idsToKeep.contains(id));

      for (final id in idsToDelete) {
        await (delete(executorOffices)..where((o) => o.id.equals(id))).go();
      }

      for (final office in newOffices.where((o) => o.id != 0)) {
        final dto = office.toDto(regionId).copyWith(id: Value(office.id));
        await (update(executorOffices)..where((o) => o.id.equals(office.id))).write(dto);
      }

      for (final office in newOffices.where((o) => o.id == 0)) {
        await into(executorOffices).insert(office.toDto(regionId));
      }
    });
  }
}