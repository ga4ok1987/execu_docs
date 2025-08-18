import 'package:dartz/dartz.dart';
import 'package:execu_docs/domain/entities/executor_entity.dart';

import '../../core/failure.dart';

abstract class ExecutorRepository{
  Future<Either<Failure, Unit>> addExecutor(ExecutorEntity entity);
  Future<Either<Failure, Unit>> delExecutor(int id);
  Future<Either<Failure, Unit>> updateExecutor(ExecutorEntity executor);
  Future<Either<Failure, List<ExecutorEntity>>> getExecutorsById(int regionId);
}