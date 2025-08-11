import 'package:dartz/dartz.dart';
import 'package:execu_docs/core/failure.dart';
import 'package:injectable/injectable.dart';

import '../repositories/region_repository.dart';

@injectable
class SeedRegionsUseCase {
  final RegionRepository repository;

  SeedRegionsUseCase(this.repository);

  Future<Either<Failure, Unit>> call(List<String> regionNames) async {
    return await repository.seedRegions(regionNames);
  }
}
