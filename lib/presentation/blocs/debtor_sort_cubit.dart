import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../core/constants/index.dart';

@injectable
class DebtorSortCubit extends Cubit<DebtorSortState> {
  DebtorSortCubit()
    : super(const DebtorSortState(column: AppTexts.number, ascending: true));

  void toggleColumn(String column) {
    if (state.column == column) {
      emit(DebtorSortState(column: column, ascending: !state.ascending));
    } else {
      emit(DebtorSortState(column: column, ascending: true));
    }
  }
}

class DebtorSortState {
  final String column;
  final bool ascending;

  const DebtorSortState({required this.column, required this.ascending});
}
