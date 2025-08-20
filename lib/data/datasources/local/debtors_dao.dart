import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/entities/debtor_entity.dart';
import 'database.dart';

part 'debtors_dao.g.dart';

@lazySingleton
@DriftAccessor(tables: [Debtors])
class DebtorsDao extends DatabaseAccessor<AppDatabase> with _$DebtorsDaoMixin {
  DebtorsDao(super.db);

  Future<void> insertDebtor(DebtorEntity debtor) async =>
      await into(debtors).insert(
        DebtorsCompanion(
          fullName: Value(debtor.fullName),
          decree: Value(debtor.decree),
          amount: Value(debtor.amount),
          address: Value(debtor.address),
          regionId: Value(debtor.regionId),
          executorId: Value(debtor.executorId),
        ),
      );

  Future<void> clearDebtors() async {
    await delete(debtors).go();
  }

  Future<void> updateDebtor(DebtorEntity debtor) async =>
      await (update(debtors)..where((tbl) => tbl.id.equals(debtor.id))).write(
        DebtorsCompanion(
          fullName: Value(debtor.fullName),
          decree: Value(debtor.decree),
          amount: Value(debtor.amount),
          address: Value(debtor.address),
          regionId: Value(debtor.regionId),
          executorId: Value(debtor.executorId),
        ),
      );

  Future<void> deleteDebtor(int id) =>
      (delete(debtors)..where((tbl) => tbl.id.equals(id))).go();

  Future<List<DebtorEntity>> getAllDebtors() async {
    final rows = await select(debtors).get();
    return rows
        .map(
          (row) => DebtorEntity(
            id: row.id,
            fullName: row.fullName,
            decree: row.decree,
            amount: row.amount,
            address: row.address,
            regionId: row.regionId,
            executorId: row.executorId,
          ),
        )
        .toList();
  }

  Future<List<DebtorEntity>> getDebtorsByRegion(int regionId) async {
    final query = select(debtors)
      ..where((tbl) => tbl.regionId.equals(regionId));
    final rows = await query.get();
    return rows
        .map(
          (row) => DebtorEntity(
            id: row.id,
            fullName: row.fullName,
            decree: row.decree,
            amount: row.amount,
            address: row.address,
            regionId: row.regionId,
            executorId: row.executorId,
          ),
        )
        .toList();
  }

  Future<List<DebtorEntity>> getDebtorsByExecutor(int executorId) async {
    final query = select(debtors)
      ..where((tbl) => tbl.executorId.equals(executorId));
    final rows = await query.get();
    return rows
        .map(
          (row) => DebtorEntity(
            id: row.id,
            fullName: row.fullName,
            decree: row.decree,
            amount: row.amount,
            address: row.address,
            regionId: row.regionId,
            executorId: row.executorId,
          ),
        )
        .toList();
  }


}
