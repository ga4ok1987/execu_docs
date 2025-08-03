import 'package:drift/drift.dart';
import 'package:execu_docs/domain/entities/region_entity.dart';

import '../../domain/entities/executor_office_entity.dart';
import '../datasources/local/database.dart';

extension RegionDtoMapper on RegionDto {
  RegionEntity toEntity(List<ExecutorOfficeEntity> offices) {
    return RegionEntity(id: id, name: name, executorOffices: offices);
  }
}

extension RegionEntityMapper on RegionEntity {
  RegionsCompanion toDto() => RegionsCompanion(name: Value(name));
}

