import 'package:execu_docs/domain/repositories/region_repository.dart';

class DelRegionUseCase {
  final RegionRepository repository;

  DelRegionUseCase(this.repository);


Future<void> call(int id) async => await repository.deleteRegion(id);
}