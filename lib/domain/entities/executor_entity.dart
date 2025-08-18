import 'package:freezed_annotation/freezed_annotation.dart';

part 'executor_entity.freezed.dart';

@freezed
abstract class ExecutorEntity with _$ExecutorEntity {
  const factory ExecutorEntity({
    required int id,
    required String name,
    required String address,
    @Default(false) bool isPrimary,
    required int regionId,
  }) = _ExecutorEntity;
}
