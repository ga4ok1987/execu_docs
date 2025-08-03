import 'package:drift/drift.dart';

class Regions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
}