import 'package:execu_docs/domain/entities/region_entity.dart';
import 'package:injectable/injectable.dart';

import '../repositories/region_repository.dart';
@injectable
class SeedRegionsUseCase {
  final RegionRepository repository;

  SeedRegionsUseCase(this.repository);

  Future<void> call(List<String> regionNames) async {
    return await repository.seedRegions(regionNames);
  }
}