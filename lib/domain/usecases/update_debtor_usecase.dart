import 'package:injectable/injectable.dart';
import '../entities/debtor_entity.dart';
import '../repositories/debtor_repository.dart';

@injectable
class UpdateDebtorUseCase {
  final DebtorRepository repository;

  UpdateDebtorUseCase(this.repository);

  Future<bool> call(DebtorEntity debtor) {
    return repository.updateDebtor(debtor);
  }
}
