
import '../entities/debtor_entity.dart';

abstract class DebtorRepository {
  Future<bool> updateDebtor(DebtorEntity debtor);
  Future<int> insertDebtor(DebtorEntity debtor);
  Future<int> deleteDebtor(int id);
  Future<List<DebtorEntity>> getAllDebtors();
}

