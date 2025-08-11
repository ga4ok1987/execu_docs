import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../core/failure.dart';
import '../repositories/debtor_repository.dart';
import '../repositories/region_repository.dart';

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