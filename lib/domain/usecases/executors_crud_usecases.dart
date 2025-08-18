import 'package:dartz/dartz.dart';
import 'package:execu_docs/core/failure.dart';
import 'package:execu_docs/domain/entities/executor_entity.dart';
import 'package:execu_docs/domain/repositories/executor_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddExecutorUseCase {
  final ExecutorRepository repository;

  AddExecutorUseCase(this.repository);

  Future<Either<Failure, Unit>> call(ExecutorEntity executor) async {
    return await repository.addExecutor(executor);
  }
}

@injectable
class DelExecutorUseCase {
  final ExecutorRepository repository;

  DelExecutorUseCase(this.repository);

  Future<Either<Failure, Unit>> call(int id) async {
    return await repository.delExecutor(id);
  }
}

@injectable
class GetExecutorsByRegionIdUseCase {
  final ExecutorRepository repository;

  GetExecutorsByRegionIdUseCase(this.repository);

  Future<Either<Failure, List<ExecutorEntity>>> call(int regionId) async {
    return await repository.getExecutorsById(regionId);
  }
}

@injectable
class UpdateExecutorUseCase {
  final ExecutorRepository repository;

  UpdateExecutorUseCase(this.repository);

  Future<Either<Failure, Unit>> call(ExecutorEntity executor) async {
    return await repository.updateExecutor(executor);
  }
}
