import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

part 'database.g.dart';

@DataClassName('DebtorsDto')
class Debtors extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get fullName => text().withLength(min: 0, max: 128)();
  TextColumn get decree => text().withLength(min: 0, max: 128)();
  TextColumn get amount => text().withLength(min: 0, max: 128)();
  TextColumn get address => text().withLength(min: 0, max: 128)();
  IntColumn get regionId => integer().nullable()();
  IntColumn get executorId => integer().nullable()();
}

@DataClassName('RegionDto')
class Regions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
}

@DataClassName('ExecutorOfficeDto')
class ExecutorOffices extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get address => text()();
  BoolColumn get isPrimary => boolean().withDefault(Constant(false))();
  IntColumn get regionId => integer().references(Regions, #id)();
}

@lazySingleton
@DriftDatabase(tables: [Debtors, Regions, ExecutorOffices])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = p.join(dir.path, 'execu_docs.sqlite');
    final file = File(path);
    return NativeDatabase(file);
  });
}
