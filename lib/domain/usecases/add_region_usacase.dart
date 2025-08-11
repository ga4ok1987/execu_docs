import 'package:dartz/dartz.dart';
import 'package:execu_docs/core/failure.dart';
import 'package:execu_docs/domain/entities/region_entity.dart';
import 'package:execu_docs/domain/repositories/region_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddRegionUseCase {
  final RegionRepository repository;

  AddRegionUseCase(this.repository);

  Future<Either<Failure, Unit>> call(RegionEntity region) async {
    return await repository.addRegion(region);
  }
}
