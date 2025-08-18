import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../core/failure.dart';
import '../entities/region_entity.dart';
import '../repositories/region_repository.dart';

@injectable
class UpdateRegionUseCase {
  final RegionRepository repository;

  UpdateRegionUseCase(this.repository);

  Future<Either<Failure, Unit>> call(RegionEntity region) async {
    return  repository.updateRegion(region.id, region.executorOffices);


  }
}