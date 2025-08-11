import 'package:dartz/dartz.dart';
import 'package:execu_docs/core/failure.dart';
import 'package:execu_docs/domain/repositories/region_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateRegionNameUseCase {
  final RegionRepository repository;

  UpdateRegionNameUseCase(this.repository);

  Future<Either<Failure, Unit>> call(int regionId, String newName) async {
    return repository.updateRegionName(regionId, newName);
  }
}