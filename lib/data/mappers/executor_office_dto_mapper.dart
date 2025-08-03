import 'package:drift/drift.dart';

import '../../domain/entities/executor_office_entity.dart';
import '../datasources/local/database.dart';

extension ExecutorOfficeDtoMapper on ExecutorOfficeDto {
  ExecutorOfficeEntity toEntity() {
    return ExecutorOfficeEntity(
      id: id,
      name: name,
    );
  }
}


extension ExecutorOfficeEntityMapper on ExecutorOfficeEntity {
ExecutorOfficesCompanion toDto(int regionId) {
  return ExecutorOfficesCompanion(
    name: Value(name),
    regionId: Value(regionId),
  );
}
}
