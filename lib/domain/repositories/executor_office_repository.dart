import '../entities/executor_office_entity.dart';

abstract class ExecutorOfficeRepository {
  Future<List<ExecutorOfficeEntity>> getByRegion(int regionId);
  Future<void> addExecutorOffice(ExecutorOfficeEntity entity);
  Future<void> deleteExecutorOffice(int id);
  Future<void> updateExecutor(ExecutorOfficeEntity entity);
    Future<void> getExecutorOfficesById(ExecutorOfficeEntity entity);

}
