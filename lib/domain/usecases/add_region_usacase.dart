import 'package:execu_docs/domain/entities/region_entity.dart';
import 'package:execu_docs/domain/repositories/region_repository.dart';

class AddRegionUseCase {
  final RegionRepository repository;

  AddRegionUseCase(this.repository);

  Future<void> call(RegionEntity region) async => repository.addRegion(region);
}
