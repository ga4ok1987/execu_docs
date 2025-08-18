import 'package:drift/drift.dart';
import 'package:execu_docs/data/datasources/local/database.dart';
import 'package:execu_docs/domain/entities/executor_entity.dart';
import 'package:injectable/injectable.dart';

part 'executor_dao.g.dart';

@lazySingleton
@DriftAccessor(tables: [ExecutorOffices])
class ExecutorDao extends DatabaseAccessor<AppDatabase>
    with _$ExecutorDaoMixin {
  ExecutorDao(super.db);

  Future<List<ExecutorEntity>> getExecutorsByRegion(int regionId) async {
    final data = await (select(
      executorOffices,
    )..where((tbl) => tbl.regionId.equals(regionId))).get();

    return data
        .map(
          (executor) => ExecutorEntity(
            id: executor.id,
            name: executor.name,
            address: executor.address,
            regionId: executor.regionId,
            isPrimary: executor.isPrimary,
          ),
        )
        .toList();
  }

  Future<void> insertExecutor(ExecutorOfficesCompanion executor) async {
    if (executor.isPrimary.value) {
      await (update(executorOffices)
            ..where((tbl) => tbl.regionId.equals(executor.regionId.value)))
          .write(ExecutorOfficesCompanion(isPrimary: Value(false)));
    }
    await into(executorOffices).insert(executor);
  }

  Future<void> deleteExecutor(int id) =>
      (delete(executorOffices)..where((tbl) => tbl.id.equals(id))).go();

  Future<void> updateExecutor(ExecutorOfficesCompanion updated) async {
    if (updated.isPrimary.value) {
      await (update(executorOffices)
            ..where((tbl) => tbl.regionId.equals(updated.regionId.value)))
          .write(ExecutorOfficesCompanion(isPrimary: Value(false)));
    }
    await update(executorOffices).replace(updated);
  }
}
