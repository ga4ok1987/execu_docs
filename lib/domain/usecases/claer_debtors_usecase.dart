import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../core/failure.dart';
import '../repositories/debtor_repository.dart';

@injectable
class ClearDebtorsUseCase {
  final DebtorRepository repository;

  ClearDebtorsUseCase(this.repository);

  Future<Either<Failure, Unit>> call() async{
    return await repository.clearDebtors();
  }
}
