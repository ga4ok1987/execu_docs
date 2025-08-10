import 'package:injectable/injectable.dart';

import '../../domain/entities/debtor_entity.dart';
import '../../domain/repositories/debtor_repository.dart';
import '../datasources/local/database.dart';
import '../datasources/local/debtors_dao.dart';
import 'package:drift/drift.dart';

@LazySingleton(as: DebtorRepository)

class DebtorRepositoryImpl implements DebtorRepository {
  final DebtorsDao dao;

  DebtorRepositoryImpl(this.dao);

  @override
  Future<int> insertDebtor(DebtorEntity debtor) {
    return dao.insertDebtor(
      DebtorsCompanion(
        fullName: Value(debtor.fullName),
        decree: Value(debtor.decree),
        amount: Value(debtor.amount),
        address: Value(debtor.address),
        regionId: Value(debtor.regionId),
        executorId: Value(debtor.executorId),
      ),
    );
  }

  @override
  Future<bool> updateDebtor(DebtorEntity debtor) {
    return dao.updateDebtor(debtor);
  }

  @override
  Future<int> deleteDebtor(int id) {
    return dao.deleteDebtor(id);
  }

  @override
  Future<List<DebtorEntity>> getAllDebtors() {
    return dao.getAllDebtors();
  }
}
