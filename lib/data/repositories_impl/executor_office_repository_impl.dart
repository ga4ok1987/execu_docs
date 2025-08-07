import 'package:execu_docs/domain/entities/executor_office_entity.dart';
import 'package:execu_docs/domain/repositories/executor_office_repository.dart';

import '../datasources/local/database.dart';
import '../datasources/local/executor_office_dao.dart';
import '../mappers/executor_office_dto_mapper.dart';

class ExecutorOfficeRepositoryImpl implements ExecutorOfficeRepository {
  final ExecutorDao dao;

  ExecutorOfficeRepositoryImpl(this.dao);

  @override
  Future<void> addExecutor(ExecutorOfficeEntity entity) async {
    final dto = ExecutorOfficeDtoMapperExt.fromEntity(entity);
    await dao.insertExecutor(dto.toCompanion(true));
  }

  @override
  Future<void> deleteExecutor(int id) => dao.deleteExecutor(id);

  @override
  Future<void> updateExecutor(ExecutorOfficeEntity entity) async {
    final dto = ExecutorOfficeDtoMapperExt.fromEntity(entity);
    await dao.updateExecutor(dto);
  }


  @override
  Future<List<ExecutorOfficeEntity>> getByRegion(int regionId) async {
    final dtos = await dao.getExecutorsByRegion(regionId);
    return dtos.map((dto) => dto.toEntity()).toList();
  }

}
