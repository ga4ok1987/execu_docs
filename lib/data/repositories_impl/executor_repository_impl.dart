import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import 'package:execu_docs/core/failure.dart';
import 'package:execu_docs/data/datasources/local/database.dart';
import 'package:execu_docs/data/datasources/local/executor_office_dao.dart';
import 'package:execu_docs/domain/entities/executor_office_entity.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/executor_repository.dart';

@LazySingleton(as: ExecutorRepository)
class ExecutorRepositoryImpl implements ExecutorRepository {
  final ExecutorDao _executorDao;

  ExecutorRepositoryImpl(this._executorDao);

  @override
  Future<Either<Failure, Unit>> addExecutor(ExecutorOfficeEntity entity) async {
    try {
      final companion = ExecutorOfficesCompanion(
        name: Value(entity.name),
        address: Value(entity.address),
        isPrimary: Value(entity.isPrimary),
        regionId: Value(entity.regionId),
      );
      await _executorDao.insertExecutor(companion);
      return const Right(unit);
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> delExecutor(int id) async {
    try {
      await _executorDao.deleteExecutor(id);
      return const Right(unit);
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, List<ExecutorOfficeEntity>>> getExecutorsById(
    int regionId,
  ) async {
    final data = await _executorDao.getExecutorsByRegion(regionId);
    try {
      final executors = data
          .where((executor) => executor.regionId == regionId)
          .toList();
      return Right(executors);
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateExecutor(
    ExecutorOfficeEntity entity,
  ) async {
    try {
      final companion = ExecutorOfficesCompanion(
        name: Value(entity.name),
        address: Value(entity.address),
        isPrimary: Value(entity.isPrimary),
        regionId: Value(entity.regionId),
      );
      await _executorDao.updateExecutor(companion);
      return const Right(unit);
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }
}
