import 'package:drift/drift.dart';
import 'package:execu_docs/data/datasources/local/database.dart';
import 'package:execu_docs/domain/entities/executor_office_entity.dart';
import 'package:injectable/injectable.dart';

part 'executor_office_dao.g.dart';
@lazySingleton
@DriftAccessor(tables: [ExecutorOffices])
class ExecutorDao extends DatabaseAccessor<AppDatabase>
    with _$ExecutorDaoMixin {
  ExecutorDao(super.db);

  Future<List<ExecutorOfficeEntity>> getExecutorsByRegion(int regionId) async {
    final data = await (select(
      executorOffices,
    )
      ..where((tbl) => tbl.regionId.equals(regionId))).get();

    return data.map((executor) =>
        ExecutorOfficeEntity(
            id: executor.id,
            name: executor.name,
            address: executor.address,regionId:
            executor.regionId)).toList();
  }

  Future<void> insertExecutor(ExecutorOfficesCompanion executor) =>
      into(executorOffices).insert(executor);

  Future<void> deleteExecutor(int id) =>
      (delete(executorOffices)
        ..where((tbl) => tbl.id.equals(id))).go();

  Future<void> updateExecutor(ExecutorOfficesCompanion updated) =>
      update(executorOffices).replace(updated);
}
