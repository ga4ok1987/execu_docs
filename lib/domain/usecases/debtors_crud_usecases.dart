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

@injectable
class ClearDebtorsUseCase {
  final DebtorRepository repository;

  ClearDebtorsUseCase(this.repository);

  Future<Either<Failure, Unit>> call() async{
    return await repository.clearDebtors();
  }
}

@injectable
class DeleteDebtorUseCase {
  final DebtorRepository repository;

  DeleteDebtorUseCase(this.repository);

  Future<Either<Failure, Unit>> call(int id) async{
    return await repository.deleteDebtor(id);
  }
}

@injectable
class GetDebtorsUseCase {
  final DebtorRepository repository;

  GetDebtorsUseCase(this.repository);

  Future<Either<Failure, List<DebtorEntity>>> call() async {
    return await repository.getAllDebtors();
  }
}


@injectable
class UpdateDebtorUseCase {
  final DebtorRepository repository;

  UpdateDebtorUseCase(this.repository);

  Future<Either<Failure, Unit>> call(DebtorEntity debtor) async{
    return await repository.updateDebtor(debtor);
  }
}
