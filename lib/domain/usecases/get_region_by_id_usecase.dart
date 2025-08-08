import 'package:injectable/injectable.dart';

import '../entities/region_entity.dart';
import '../repositories/region_repository.dart';
@injectable
class GetRegionByIdUseCase {
  final RegionRepository repository;

  GetRegionByIdUseCase(this.repository);

  Future<RegionEntity> call(int regionId) async {
    final regions = await repository.getAllRegions();
    return regions.firstWhere(
          (region) => region.id == regionId,
      orElse: () => const RegionEntity(id: -1, name: 'Не знайдено'),
    );
  }
}