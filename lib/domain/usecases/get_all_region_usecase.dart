import 'package:execu_docs/domain/entities/region_entity.dart';

import '../repositories/region_repository.dart';

class GetAllRegionsUseCase {
  final RegionRepository repository;

  GetAllRegionsUseCase(this.repository);

  Future<List<RegionEntity>> call() async {
    return await repository.getAllRegions();
  }
}