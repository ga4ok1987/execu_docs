import 'package:execu_docs/domain/repositories/region_repository.dart';
import 'package:injectable/injectable.dart';
@injectable
class UpdateRegionNameUseCase {
  final RegionRepository repository;

  UpdateRegionNameUseCase(this.repository);

  Future<void> call(int regionId, String newName) async {
    await repository.updateRegionName(regionId, newName);
  }
}