import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class PanelsCubit extends Cubit<PanelsState> {
  PanelsCubit() : super(const PanelsState());

  void toggleRegionPanel() =>
      emit(state.copyWith(isRegionPanelOpen: !state.isRegionPanelOpen));

  void openExecutorPanel() =>
      emit(state.copyWith(isExecutorPanelOpen: true));

  void closeExecutorPanel() =>
      emit(state.copyWith(isExecutorPanelOpen: false));

  void closeAll() => emit(const PanelsState());
}

class PanelsState {
  final bool isRegionPanelOpen;
  final bool isExecutorPanelOpen;

  const PanelsState({
    this.isRegionPanelOpen = false,
    this.isExecutorPanelOpen = false,
  });

  PanelsState copyWith({
    bool? isRegionPanelOpen,
    bool? isExecutorPanelOpen,
  }) {
    return PanelsState(
      isRegionPanelOpen: isRegionPanelOpen ?? this.isRegionPanelOpen,
      isExecutorPanelOpen: isExecutorPanelOpen ?? this.isExecutorPanelOpen,
    );
  }
}

