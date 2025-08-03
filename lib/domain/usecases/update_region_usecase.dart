import 'package:execu_docs/domain/entities/region_entity.dart';

import '../repositories/region_repository.dart';

class UpdateRegionUseCase {
  final RegionRepository repository;

  UpdateRegionUseCase(this.repository);

  Future<void> call(RegionEntity region) async {
    await repository.updateRegion(region);
  }
}