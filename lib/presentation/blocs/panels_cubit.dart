import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class PanelsCubit extends Cubit<PanelsState> {
  PanelsCubit()
    : super(
        const PanelsState(isRegionPanelOpen: false, isExecutorPanelOpen: false),
      );

  void toggleRegionPanel() {
    // Якщо відкриваємо RegionPanel, можна закрити ExecutorPanel
    final newRegionState = !state.isRegionPanelOpen;
    emit(
      state.copyWith(
        isRegionPanelOpen: newRegionState,
        isExecutorPanelOpen: newRegionState ? state.isExecutorPanelOpen : false,
      ),
    );
  }

  void closeExecutorPanel() => emit(state.copyWith(isExecutorPanelOpen: false));

  void openExecutorPanel() => emit(state.copyWith(isExecutorPanelOpen: true));

  void closeAll() => emit(
    const PanelsState(isRegionPanelOpen: false, isExecutorPanelOpen: false),
  );
}

class PanelsState {
  final bool isRegionPanelOpen;
  final bool isExecutorPanelOpen;

  const PanelsState({
    this.isRegionPanelOpen = false,
    this.isExecutorPanelOpen = false,
  });

  PanelsState copyWith({bool? isRegionPanelOpen, bool? isExecutorPanelOpen}) {
    return PanelsState(
      isRegionPanelOpen: isRegionPanelOpen ?? this.isRegionPanelOpen,
      isExecutorPanelOpen: isExecutorPanelOpen ?? this.isExecutorPanelOpen,
    );
  }

  Offset get regionOffset {
    if (!isRegionPanelOpen) return const Offset(1.0, 0);
    return isExecutorPanelOpen ? const Offset(-0.2, 0) : const Offset(0, 0);
  }

  Offset get executorOffset =>
      isExecutorPanelOpen ? const Offset(0, 0) : const Offset(1.0, 0);
}
