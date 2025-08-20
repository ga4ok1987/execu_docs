import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../core/failure.dart';
import '../../domain/entities/debtor_entity.dart';
import '../../domain/repositories/debtor_repository.dart';
import '../datasources/local/debtors_dao.dart';

@LazySingleton(as: DebtorRepository)
class DebtorRepositoryImpl implements DebtorRepository {
  final DebtorsDao dao;

  DebtorRepositoryImpl(this.dao);

  @override
  Future<Either<Failure, Unit>> insertDebtor(DebtorEntity debtor) async {
    try {
      await dao.insertDebtor(debtor);
      return const Right(unit);
    } catch (_) {
      return Left(DatabaseFailure());
    }
  }

  Future<Either<Failure, Unit>> clearDebtors() async {
    try {
      await dao.clearDebtors();
      return const Right(unit);
    } catch (_) {
      return Left(DatabaseFailure());
    }
  }
  @override
  Future<Either<Failure, Unit>> updateDebtor(DebtorEntity debtor) async {
    try {
       await dao.updateDebtor(debtor);
           return const Right(unit);
    } catch (_) {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteDebtor(int id) async {
    try {
      await dao.deleteDebtor(id);
      return const Right(unit);
    } catch (_) {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, List<DebtorEntity>>> getAllDebtors() async {
    try {
      final debtors = await dao.getAllDebtors();
      return Right(debtors);
    } catch (_) {
      return Left(DatabaseFailure());
    }
  }

  Future<Either<Failure, List<DebtorEntity>>> getDebtorsByRegion(int regionId) async {
    try {
      final debtors = await dao.getDebtorsByRegion(regionId);
      return Right(debtors);
    } catch (_) {
      return Left(DatabaseFailure());
    }
  }

  Future<Either<Failure, List<DebtorEntity>>> getDebtorsByExecutor(int executorId) async {
    try {
      final debtors = await dao.getDebtorsByExecutor(executorId);
      return Right(debtors);
    } catch (_) {
      return Left(DatabaseFailure());
    }
  }
}
