import 'package:dartz/dartz.dart';
import 'package:execu_docs/domain/entities/executor_office_entity.dart';

import '../../core/failure.dart';

abstract class ExecutorRepository{
  Future<Either<Failure, Unit>> addExecutor(ExecutorOfficeEntity entity);
  Future<Either<Failure, Unit>> delExecutor(int id);
  Future<Either<Failure, Unit>> updateExecutor(ExecutorOfficeEntity executor);
  Future<Either<Failure, List<ExecutorOfficeEntity>>> getExecutorsById(int regionId);
}