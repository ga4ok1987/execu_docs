import 'package:dartz/dartz.dart';
import 'package:execu_docs/core/failure.dart';
import 'package:execu_docs/domain/entities/region_entity.dart';

import '../entities/executor_office_entity.dart';

abstract class RegionRepository {
  Future<Either<Failure, List<RegionEntity>>> getAllRegions();
  Future<Either<Failure, RegionEntity>> getRegionById(int regionId);
  Future<Either<Failure, Unit>> addRegion(RegionEntity entity);
  Future<Either<Failure, Unit>> deleteRegion(int id);
  Future<Either<Failure, Unit>> updateRegionName(int regionId, String newName);
  Future<Either<Failure, Unit>> updateRegion(
    int regionId,
    List<ExecutorOfficeEntity> offices,
  );
  Future<Either<Failure, Unit>> seedRegions(List<String> regionNames);
}
