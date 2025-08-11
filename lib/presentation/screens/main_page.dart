import 'package:execu_docs/core/di/di.dart';
import 'package:execu_docs/domain/usecases/get_region_by_id_usecase.dart';
import 'package:execu_docs/domain/usecases/update_region_usecase.dart';
import 'package:execu_docs/presentation/blocs/region_cubit.dart';
import 'package:execu_docs/presentation/widgets/main_panel.dart';
import 'package:execu_docs/presentation/widgets/region_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/region_entity.dart';
import '../blocs/executor_office_cubit.dart';
import '../blocs/panels_cubit.dart';
import '../blocs/region_selection_cubit.dart';
import '../widgets/executors_offices_panel.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final double dataWidth = MediaQuery
        .of(context)
        .size
        .width * 0.35;


    return MultiBlocListener(listeners: [
    BlocListener<RegionSelectionCubit, RegionSelectionState>(
      listener: (context, state) {
        if (state.isExecutorPanelOpen) {
          context.read<PanelsCubit>().openExecutorPanel();
        } else {
          context.read<PanelsCubit>().closeExecutorPanel();
        }
      },
      
    ),
    BlocListener<PanelsCubit, PanelsState>(
      listenWhen: (previous, current) {
        // Слухаємо тільки момент, коли панель закрилась
        final wasOpen = previous.isRegionPanelOpen || previous.isExecutorPanelOpen;
        final isNowClosed = !current.isRegionPanelOpen && !current.isExecutorPanelOpen;
        return wasOpen && isNowClosed;
      },
      listener: (context, state) {
        context.read<RegionCubit>().loadRegions();
      },
    ),
    ],
      child: Stack(
        children: [
          MainPanel(),
          BlocBuilder<PanelsCubit, PanelsState>(
            builder: (context, panelState) {
              final showOverlay = panelState.isRegionPanelOpen;
              return AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: showOverlay ? 0.5 : 0.0,
                child: IgnorePointer(
                  ignoring: !showOverlay,
                  child: GestureDetector(
                    onTap: () =>
                        context.read<PanelsCubit>().closeAll(),
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.black,
                    ),
                  ),
                ),
              );
            },
          ),
          // RegionPanel
          BlocBuilder<PanelsCubit, PanelsState>(
            builder: (context, panelState) {
              // Обчислюємо наскільки треба зсунути RegionPanel
              final regionSlideOffset = panelState.isRegionPanelOpen
                  ? (panelState.isExecutorPanelOpen
                  ? const Offset(-0.2, 0) // посунути вліво на 40%
                  : const Offset(0, 0))
                  : const Offset(1.0, 0); // повністю прихована праворуч
              return AnimatedSlide(
                duration: const Duration(milliseconds: 300),
                offset: regionSlideOffset,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: dataWidth,
                    height: double.infinity,
                    child: const Material(
                      elevation: 8,
                      child: RegionPanel(),
                    ),
                  ),
                ),
              );
            },
          ),


          /// 📦 Панель Регіонів, яка зсувається, якщо відкриті Виконавці
          // ExecutorPanel
          BlocBuilder<PanelsCubit, PanelsState>(
            builder: (context, panelState) {
              final selectedRegion = context.select<
                  RegionSelectionCubit,
                  RegionEntity?>(
                    (state) => state.state.selectedRegion,
              );

              return BlocProvider(
                  key: ValueKey(selectedRegion?.id),
                create: (context) => ExecutorOfficeCubit(
                  regionId: selectedRegion!.id,
                  getRegionById: getIt<GetRegionByIdUseCase>(),
                  updateRegion: getIt<UpdateRegionUseCase>()
                ),
                child: AnimatedSlide(
                  duration: const Duration(milliseconds: 300),
                  offset: panelState.isExecutorPanelOpen
                      ? const Offset(0, 0)
                      : const Offset(1.0, 0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.4,
                      height: double.infinity,
                      child: Material(
                        elevation: 8,
                        child: selectedRegion != null
                            ? ExecutorOfficesPanel(region: selectedRegion)
                            : const SizedBox(),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
    
  }
}

