import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:execu_docs/domain/entities/region_entity.dart';
import 'package:injectable/injectable.dart';
@injectable
class RegionSelectionCubit extends Cubit<RegionSelectionState> {
  RegionSelectionCubit() : super(RegionSelectionState());

  void selectRegion(RegionEntity region) {
    emit(RegionSelectionState(selectedRegion: region, isExecutorPanelOpen: true));
  }

  void clear() {
    emit(RegionSelectionState(selectedRegion: null, isExecutorPanelOpen: false));
  }
}

class RegionSelectionState {
  final RegionEntity? selectedRegion;
  final bool isExecutorPanelOpen;

  RegionSelectionState({
    this.selectedRegion,
    this.isExecutorPanelOpen = false,
  });

  RegionSelectionState copyWith({
    RegionEntity? selectedRegion,
    bool? isExecutorPanelOpen,
  }) {
    return RegionSelectionState(
      selectedRegion: selectedRegion ?? this.selectedRegion,
      isExecutorPanelOpen: isExecutorPanelOpen ?? this.isExecutorPanelOpen,
    );
  }
}

