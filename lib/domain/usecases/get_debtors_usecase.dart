import 'package:dartz/dartz.dart';
import 'package:execu_docs/core/failure.dart';
import 'package:injectable/injectable.dart';
import '../entities/debtor_entity.dart';
import '../repositories/debtor_repository.dart';

@injectable
class GetDebtorsUseCase {
  final DebtorRepository repository;

  GetDebtorsUseCase(this.repository);

  Future<Either<Failure, List<DebtorEntity>>> call() async {
    return await repository.getAllDebtors();
  }
}
