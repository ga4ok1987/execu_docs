import 'package:injectable/injectable.dart';
import '../entities/debtor_entity.dart';
import '../repositories/debtor_repository.dart';

@injectable
class AddDebtorUseCase {
  final DebtorRepository repository;

  AddDebtorUseCase(this.repository);

  Future<int> call(DebtorEntity debtor) {
    return repository.insertDebtor(debtor);
  }
}
