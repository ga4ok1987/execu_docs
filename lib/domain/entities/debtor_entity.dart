
import 'package:freezed_annotation/freezed_annotation.dart';

part 'debtor_entity.freezed.dart';

@freezed
abstract class DebtorEntity with _$DebtorEntity{
  const factory DebtorEntity({
    required int id,
    required String fullName,
    required String decree,
    required String amount,
    required String address,
    required int? regionId,
    required int? executorId,
  }) = _DebtorEntity;
}

