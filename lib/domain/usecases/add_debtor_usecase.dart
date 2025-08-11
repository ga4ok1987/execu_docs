import 'package:dartz/dartz.dart';
import 'package:execu_docs/core/failure.dart';
import 'package:injectable/injectable.dart';
import '../entities/debtor_entity.dart';
import '../repositories/debtor_repository.dart';

@injectable
class AddDebtorUseCase {
  final DebtorRepository repository;

  AddDebtorUseCase(this.repository);

  Future<Either<Failure, Unit>> call(DebtorEntity debtor) async{
    return await repository.insertDebtor(debtor);
  }
}
