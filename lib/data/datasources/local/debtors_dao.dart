import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/entities/debtor_entity.dart';
import 'database.dart';

part 'debtors_dao.g.dart';
@lazySingleton
@DriftAccessor(tables: [Debtors])
class DebtorsDao extends DatabaseAccessor<AppDatabase> with _$DebtorsDaoMixin {
  DebtorsDao(super.db);

  Future<int> insertDebtor(DebtorsCompanion debtor) =>
      into(debtors).insert(debtor);

  Future<bool> updateDebtor(DebtorEntity debtor) async {
    final rowsUpdated = await (update(debtors)..where((tbl) => tbl.id.equals(debtor.id)))
        .write(
      DebtorsCompanion(
        fullName: Value(debtor.fullName),
        decree: Value(debtor.decree),
        amount: Value(debtor.amount),
        address: Value(debtor.address),
        regionId: Value(debtor.regionId),
        executorId: Value(debtor.executorId),
      ),
    );
    return rowsUpdated > 0;
  }

  Future<int> deleteDebtor(int id) =>
      (delete(debtors)..where((tbl) => tbl.id.equals(id))).go();

  Future<List<DebtorEntity>> getAllDebtors() async {
    final rows = await select(debtors).get();
    return rows.map((row) => DebtorEntity(
      id: row.id,
      fullName: row.fullName,
      decree: row.decree,
      amount: row.amount,
      address: row.address,
      regionId: row.regionId,
      executorId: row.executorId,
    )).toList();
  }
}
