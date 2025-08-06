import '../entities/executor_office_entity.dart';

abstract class ExecutorOfficeRepository {
  Future<List<ExecutorOfficeEntity>> getByRegion(int regionId);
  Future<void> addExecutor(ExecutorOfficeEntity entity, int regionId);
  Future<void> deleteExecutor(int id);
  Future<void> updateExecutor(ExecutorOfficeEntity entity, int regionId);
}
