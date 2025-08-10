import 'package:injectable/injectable.dart';
import '../entities/debtor_entity.dart';
import '../repositories/debtor_repository.dart';

@injectable
class GetDebtorsUseCase {
  final DebtorRepository repository;

  GetDebtorsUseCase(this.repository);

  Future<List<DebtorEntity>> call() {
    return repository.getAllDebtors();
  }
}
