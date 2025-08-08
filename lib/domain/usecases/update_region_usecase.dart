import 'package:injectable/injectable.dart';

import '../entities/region_entity.dart';
import '../repositories/region_repository.dart';

@injectable
class UpdateRegionUseCase {
  final RegionRepository repository;

  UpdateRegionUseCase(this.repository);

  Future<void> call(RegionEntity region) async {
    await repository.updateExecutorOffices(region.id, region.executorOffices);


  }
}