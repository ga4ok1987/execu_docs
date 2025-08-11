import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../core/failure.dart';
import '../entities/region_entity.dart';
import '../repositories/region_repository.dart';

@injectable
class GetRegionByIdUseCase {
  final RegionRepository repository;

  GetRegionByIdUseCase(this.repository);

  Future<Either<Failure, RegionEntity>> call(int regionId) async {
    return await repository.getRegionById(regionId);
  }
}
