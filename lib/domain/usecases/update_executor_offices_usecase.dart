import 'package:execu_docs/domain/entities/region_entity.dart';
import 'package:injectable/injectable.dart';

import '../entities/executor_office_entity.dart';
import '../repositories/region_repository.dart';
@injectable
class UpdateExecutorOfficesUseCase {
  final RegionRepository repository;

  UpdateExecutorOfficesUseCase(this.repository);

  Future<void> call(int regionId,List<ExecutorOfficeEntity> offices) async {
    await repository.updateExecutorOffices(regionId, offices);
  }
}