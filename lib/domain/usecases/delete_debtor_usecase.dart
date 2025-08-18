import 'package:dartz/dartz.dart';
import 'package:execu_docs/core/failure.dart';
import 'package:injectable/injectable.dart';
import '../repositories/debtor_repository.dart';

@injectable
class DeleteDebtorUseCase {
  final DebtorRepository repository;

  DeleteDebtorUseCase(this.repository);

  Future<Either<Failure, Unit>> call(int id) async{
    return await repository.deleteDebtor(id);
  }
}
