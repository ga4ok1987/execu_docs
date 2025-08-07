import 'package:drift/drift.dart';
import 'package:execu_docs/domain/entities/executor_office_entity.dart';
import '../datasources/local/database.dart';

extension ExecutorOfficeDtoMapper on ExecutorOfficeDto {
  ExecutorOfficeEntity toEntity() {
    return ExecutorOfficeEntity(
      id: id,
      name: name,
      address: address,
      isPrimary: isPrimary,
      regionId: regionId,
    );
  }
}

extension ExecutorOfficeEntityMapper on ExecutorOfficeEntity {
  ExecutorOfficesCompanion toDto({required int regionId}) {
    return ExecutorOfficesCompanion(
      name: Value(name),
      address: Value(address),
      isPrimary: Value(isPrimary),
      regionId: Value(regionId),
    );
  }
}

extension ExecutorOfficeDtoMapperExt on ExecutorOfficeDto {
  static ExecutorOfficeDto fromEntity(ExecutorOfficeEntity entity,) {
    return ExecutorOfficeDto(
      id: entity.id,
      name: entity.name,
      address: entity.address,
      isPrimary: entity.isPrimary,
      regionId: entity.regionId,
    );
  }
}


