import 'package:dartz/dartz.dart';
import '../../core/failure.dart';
import '../entities/debtor_entity.dart';

abstract class DebtorRepository {
  Future<Either<Failure, Unit>> insertDebtor(DebtorEntity debtor);

  Future<Either<Failure, Unit>> updateDebtor(DebtorEntity debtor);

  Future<Either<Failure, Unit>> deleteDebtor(int id);

  Future<Either<Failure, List<DebtorEntity>>> getAllDebtors();
  Future<Either<Failure, List<DebtorEntity>>> getDebtorsByRegion(int regionId);
  Future<Either<Failure, List<DebtorEntity>>> getDebtorsByExecutor(int executorId);
}