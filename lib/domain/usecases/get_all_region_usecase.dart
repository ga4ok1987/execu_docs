import 'package:dartz/dartz.dart';
import 'package:execu_docs/core/failure.dart';
import 'package:execu_docs/domain/entities/region_entity.dart';
import 'package:injectable/injectable.dart';
import '../repositories/region_repository.dart';

@injectable
class GetAllRegionsUseCase {
  final RegionRepository repository;

  GetAllRegionsUseCase(this.repository);

  Future<Either<Failure, List<RegionEntity>>> call() async {
    return await repository.getAllRegions();
  }
}
