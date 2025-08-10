import 'package:execu_docs/domain/usecases/add_debtor_usecase.dart';
import 'package:execu_docs/domain/usecases/delete_debtor_usecase.dart';
import 'package:execu_docs/domain/usecases/get_debtors_usecase.dart';
import 'package:execu_docs/domain/usecases/update_debtor_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/debtor_entity.dart';
import '../../domain/repositories/debtor_repository.dart';

@injectable
class DebtorCubit extends Cubit<List<DebtorEntity>> {
  final AddDebtorUseCase addDebtorUseCase;
  final UpdateDebtorUseCase updateDebtorUseCase;
  final DeleteDebtorUseCase deleteDebtorUseCase;
  final GetDebtorsUseCase getDebtorsUseCase;

  DebtorCubit({
    required this.addDebtorUseCase,
    required this.updateDebtorUseCase,
    required this.deleteDebtorUseCase,
    required this.getDebtorsUseCase,
  }) : super([]);

  Future<void> loadDebtors() async {
    final debtors = await getDebtorsUseCase();
    emit(debtors);
  }

  Future<void> updateDebtor(DebtorEntity debtor) async {
    await updateDebtorUseCase(debtor);
    await loadDebtors();
  }
  Future<void> addDebtor(DebtorEntity debtor) async {
    await addDebtorUseCase.call(debtor);
    await loadDebtors(); // оновити список після додавання
  }

}
