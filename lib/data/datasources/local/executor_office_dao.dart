import 'package:drift/drift.dart';
import 'package:execu_docs/data/datasources/local/database.dart';

part 'executor_office_dao.g.dart';

@DriftAccessor(tables: [ExecutorOffices])
class ExecutorDao extends DatabaseAccessor<AppDatabase> with _$ExecutorDaoMixin {
  ExecutorDao(super.db);

  Future<List<ExecutorOfficeDto>> getExecutorsByRegion(int regionId) {
    return (select(executorOffices)..where((tbl) => tbl.regionId.equals(regionId))).get();
  }

  Future<void> insertExecutor(ExecutorOfficesCompanion executor) =>
      into(executorOffices).insert(executor);

  Future<void> deleteExecutor(int id) =>
      (delete(executorOffices)..where((tbl) => tbl.id.equals(id))).go();

  Future<void> updateExecutor(ExecutorOfficeDto updated) =>
      update(executorOffices).replace(updated);
}
