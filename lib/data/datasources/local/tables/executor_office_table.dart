import 'package:drift/drift.dart';

import '../database.dart';


class ExecutorOffices extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();
  TextColumn get address => text()();
  BoolColumn get isPrimary =>boolean().withDefault(Constant(false))();

  IntColumn get regionId => integer()
      .references(Regions, #id, onDelete: KeyAction.cascade)();
}