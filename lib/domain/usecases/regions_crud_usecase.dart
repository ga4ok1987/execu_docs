import 'package:dartz/dartz.dart';
import 'package:execu_docs/core/failure.dart';
import 'package:execu_docs/domain/entities/region_entity.dart';
import 'package:execu_docs/domain/repositories/region_repository.dart';
import 'package:injectable/injectable.dart';

import '../repositories/debtor_repository.dart';

@injectable
class AddRegionUseCase {
  final RegionRepository repository;

  AddRegionUseCase(this.repository);

  Future<Either<Failure, Unit>> call(RegionEntity region) async {
    return await repository.addRegion(region);
  }
}

@injectable
class GetAllRegionsUseCase {
  final RegionRepository repository;

  GetAllRegionsUseCase(this.repository);

  Future<Either<Failure, List<RegionEntity>>> call() async {
    return await repository.getAllRegions();
  }
}

@injectable
class GetRegionByIdUseCase {
  final RegionRepository repository;

  GetRegionByIdUseCase(this.repository);

  Future<Either<Failure, RegionEntity>> call(int regionId) async {
    return await repository.getRegionById(regionId);
  }
}

@injectable
class UpdateRegionNameUseCase {
  final RegionRepository repository;

  UpdateRegionNameUseCase(this.repository);

  Future<Either<Failure, Unit>> call(int regionId, String newName) async {
    return repository.updateRegionName(regionId, newName);
  }
}

@injectable
class UpdateRegionUseCase {
  final RegionRepository repository;

  UpdateRegionUseCase(this.repository);

  Future<Either<Failure, Unit>> call(RegionEntity region) async {
    return repository.updateRegion(region.id, region.executorOffices);
  }
}


@injectable
class DelRegionUseCase {
  final RegionRepository repository;
  final DebtorRepository debtorRepository;

  DelRegionUseCase(this.repository, this.debtorRepository);

  Future<Either<Failure, Unit>> call(int id) async {
    final deleteResult = await repository.deleteRegion(id);
    if (deleteResult.isLeft()) {
      return Left(deleteResult.swap().getOrElse(() => UnknownFailure()));
    }

    final debtorsResult = await debtorRepository.getAllDebtors();
    if (debtorsResult.isLeft()) {
      return Left(debtorsResult.swap().getOrElse(() => UnknownFailure()));
    }

    final debtors = debtorsResult.getOrElse(() => []);
    final affectedDebtors = debtors.where((d) => d.regionId == id).toList();

    for (final debtor in affectedDebtors) {
      final updatedDebtor = debtor.copyWith(regionId: null, executorId: null);
      final updateResult = await debtorRepository.updateDebtor(updatedDebtor);
      if (updateResult.isLeft()) {
        return Left(updateResult.swap().getOrElse(() => UnknownFailure()));
      }
    }

    return const Right(unit);
  }
}