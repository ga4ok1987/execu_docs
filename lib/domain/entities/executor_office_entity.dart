import 'package:freezed_annotation/freezed_annotation.dart';

part 'executor_office_entity.freezed.dart';

@freezed
abstract class ExecutorOfficeEntity with _$ExecutorOfficeEntity {
  const factory ExecutorOfficeEntity({
    required int id,
    required String name,
    required String address,
    @Default(false) bool isPrimary,
    required int regionId,
  }) = _ExecutorOfficeEntity;
}
