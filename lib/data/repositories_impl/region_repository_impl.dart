import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import 'package:execu_docs/core/failure.dart';
import 'package:execu_docs/data/datasources/local/database.dart';
import 'package:execu_docs/domain/entities/region_entity.dart';
import 'package:execu_docs/domain/repositories/region_repository.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/executor_office_entity.dart';
import '../datasources/local/region_dao.dart';

@LazySingleton(as: RegionRepository)
class RegionRepositoryImpl implements RegionRepository {
  final RegionDao _regionDao;

  RegionRepositoryImpl(this._regionDao);

  @override
  Future<Either<Failure, List<RegionEntity>>> getAllRegions() async {
    try {
      final data = await _regionDao.getAllRegionsWithOffices();
      return Right(data);
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, RegionEntity>> getRegionById(int regionId) async {
    final data = await _regionDao.getAllRegionsWithOffices();
    try {
      final region = data.firstWhere(
            (region) => region.id == regionId,
      );
      return Right(region);
    } on StateError {
      return Left(UnknownFailure());
    }
  }



  @override
  Future<Either<Failure, Unit>> addRegion(RegionEntity entity) async {
    try {
      final exists = await _regionDao.existsByName(entity.name);
      if (exists) {
        return Left(DuplicateRegionFailure());
      }
      final companion = RegionsCompanion(name: Value(entity.name));
      await _regionDao.insertRegion(companion);
      return const Right(unit);
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteRegion(int id) async {
    try {
      await _regionDao.deleteById(id);
      return const Right(unit);
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateRegionName(
    int regionId,
    String newName,
  ) async {
    try {
      final exists = await _regionDao.existsByName(newName);
      if (exists) {
        return Left(DuplicateRegionFailure());
      }
      await _regionDao.updateRegionName(regionId, newName);
      return const Right(unit);
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateRegion(
    int regionId,
    List<ExecutorOfficeEntity> offices,
  ) async {
    try {
      await _regionDao.updateExecutorOffices(regionId, offices);
      return const Right(unit);
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> seedRegions(List<String> regionNames) async {
    try {
      final isEmpty = await _regionDao.isEmpty();
      if (isEmpty) {
        for (final name in regionNames) {
          await _regionDao.insertRegion(RegionsCompanion(name: Value(name)));
        }
      }
      return const Right(unit);
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }
}
