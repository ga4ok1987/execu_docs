import 'package:freezed_annotation/freezed_annotation.dart';

import 'executor_office_entity.dart';

part 'region_entity.freezed.dart';

@freezed
abstract class RegionEntity with _$RegionEntity {
  const factory RegionEntity({
    required int id,
    required String name,
    @Default([]) List<ExecutorOfficeEntity> executorOffices,
  }) = _RegionEntity;
}
