import 'package:execu_docs/core/di/di.dart';
import 'package:execu_docs/presentation/blocs/region_cubit.dart';
import 'package:execu_docs/presentation/widgets/main_panel.dart';
import 'package:execu_docs/presentation/widgets/region_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/region_entity.dart';
import '../blocs/debtor_cubit.dart';
import '../blocs/executor_office_cubit.dart';
import '../blocs/panels_cubit.dart';
import '../blocs/region_selection_cubit.dart';
import '../widgets/executors_panel.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final double regionPanelWidth = MediaQuery.of(context).size.width * 0.35;
    final isImportingNotifier = ValueNotifier<bool>(false);


    return MultiBlocListener(
      listeners: [
        BlocListener<RegionSelectionCubit, RegionSelectionState>(
          listener: (context, state) {
            final panelsCubit = context.read<PanelsCubit>();
            state.isExecutorPanelOpen
                ? panelsCubit.openExecutorPanel()
                : panelsCubit.closeExecutorPanel();
          },
        ),
        BlocListener<PanelsCubit, PanelsState>(
          listenWhen: (previous, current) {
            final wasOpen =
                previous.isRegionPanelOpen || previous.isExecutorPanelOpen;
            final isNowClosed =
                !current.isRegionPanelOpen && !current.isExecutorPanelOpen;
            return wasOpen && isNowClosed;
          },
          listener: (context, state) {
            context.read<RegionCubit>().loadRegions();
          },
        ),
        BlocListener<DebtorCubit, DebtorState>(
          listener: (context, state) {
            if (state is DebtorImporting) {
              isImportingNotifier.value = true;
            } else {
              isImportingNotifier.value = false;
            }
          },
        ),

      ],
      child: ValueListenableBuilder<bool>(
          valueListenable: isImportingNotifier,
          builder: (context, isImporting, _) {
          return Stack(
            children: [
              const MainPanel(),
              _buildOverlay(context),
              _buildRegionPanel(context, regionPanelWidth),
              _buildExecutorPanel(context),
              if (isImporting)
                Positioned.fill(
                  child: IgnorePointer(
                    ignoring: false,
                    child: Container(
                      color: Colors.black.withOpacity(0.2),
                      child: const Center(
                        child: SizedBox(
                          width: 200,
                          child: Card(
                            child: Padding(
                              padding: EdgeInsets.all(24),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircularProgressIndicator(),
                                  SizedBox(width: 16),
                                  Text("Імпорт даних..."),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

            ],
          );
        }
      ),
    );
  }

  Widget _buildOverlay(BuildContext context) {
    return BlocBuilder<PanelsCubit, PanelsState>(
      builder: (context, panelState) {
        final showOverlay = panelState.isRegionPanelOpen;
        return AnimatedOpacity(
          duration: Duration(milliseconds: 300),
          opacity: showOverlay ? 0.5 : 0.0,
          child: IgnorePointer(
            ignoring: !showOverlay,
            child: GestureDetector(
              onTap: () {
                context.read<PanelsCubit>().closeAll();
                context.read<RegionSelectionCubit>().clear();
              },
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRegionPanel(BuildContext context, double width) {
    return BlocBuilder<PanelsCubit, PanelsState>(
      builder: (context, panelState) {
        return AnimatedSlide(
          duration: Duration(milliseconds: 200),
          offset: panelState.regionOffset,
          child: Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: width,
              height: double.infinity,
              child: const Material(elevation: 8, child: RegionPanel()),
            ),
          ),
        );
      },
    );
  }

  Widget _buildExecutorPanel(BuildContext context) {
    final selectedRegion = context.select<RegionSelectionCubit, RegionEntity?>(
      (state) => state.state.selectedRegion,
    );

    return BlocBuilder<PanelsCubit, PanelsState>(
      builder: (context, panelState) {
        return AnimatedSlide(
          duration: Duration(milliseconds: 200),
          offset: panelState.executorOffset,
          child: Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              height: double.infinity,
              child: Material(
                elevation: 8,
                child: selectedRegion == null
                    ? const SizedBox()
                    : BlocProvider(
                        key: ValueKey(selectedRegion.id),
                        create: (context) =>
                            getIt<ExecutorCubit>(param1: selectedRegion.id)
                              ..loadOffices(selectedRegion.id),
                        child: ExecutorsPanel(region: selectedRegion),
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}
