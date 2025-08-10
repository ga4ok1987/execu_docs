import 'package:injectable/injectable.dart';
import '../repositories/debtor_repository.dart';

@injectable
class DeleteDebtorUseCase {
  final DebtorRepository repository;

  DeleteDebtorUseCase(this.repository);

  Future<int> call(int id) {
    return repository.deleteDebtor(id);
  }
}
