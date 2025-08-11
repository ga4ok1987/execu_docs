import 'package:dartz/dartz.dart';
import 'package:execu_docs/core/failure.dart';
import 'package:injectable/injectable.dart';
import '../entities/debtor_entity.dart';
import '../repositories/debtor_repository.dart';

@injectable
class UpdateDebtorUseCase {
  final DebtorRepository repository;

  UpdateDebtorUseCase(this.repository);

  Future<Either<Failure, Unit>> call(DebtorEntity debtor) async{
    return await repository.updateDebtor(debtor);
  }
}
