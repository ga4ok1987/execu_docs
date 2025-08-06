import 'package:execu_docs/domain/entities/executor_office_entity.dart';
import 'package:execu_docs/domain/repositories/executor_office_repository.dart';

import '../datasources/local/database.dart';
import '../datasources/local/executor_office_dao.dart';

class ExecutorOfficeRepositoryImpl implements ExecutorOfficeRepository {
  final ExecutorDao dao;

  ExecutorOfficeRepositoryImpl(this.dao);

  @override
  Future<void> addExecutor(ExecutorOfficeEntity entity, int regionId) async {
    final dto = ExecutorOfficeDto.fromEntity(entity, regionId: regionId);
    await dao.insertExecutor(dto.toCompanion());
  }

  @override
  Future<void> deleteExecutor(int id) => dao.deleteExecutor(id);

  @override
  Future<void> updateExecutor(ExecutorOfficeEntity entity, int regionId) async {
    final dto = ExecutorOfficeDto.fromEntity(entity, regionId: regionId);
    final driftModel = ExecutorOfficeDto(
      id: dto.id,
      name: dto.name,
      address: dto.address,
      isPrimary: dto.isPrimary,
      regionId: dto.regionId,
    );
    await dao.updateExecutor(driftModel);
  }

  @override
  Future<List<ExecutorOfficeEntity>> getByRegion(int regionId) async {
    final rows = await dao.getExecutorsByRegion(regionId);
    return rows.map((e) => ExecutorOfficeDto.fromData(e).toEntity()).toList();
  }
}
