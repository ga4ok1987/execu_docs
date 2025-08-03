import 'package:drift/drift.dart';


class ExecutorOffices extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  IntColumn get regionId => integer()
      .customConstraint('NOT NULL REFERENCES regions(id) ON DELETE CASCADE')();
}