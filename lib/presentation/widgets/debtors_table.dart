import 'package:execu_docs/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/debtor_entity.dart';
import '../../domain/entities/executor_entity.dart';
import '../../domain/entities/region_entity.dart';
import '../blocs/debtor_cubit.dart';
import '../blocs/region_cubit.dart';

class DebtorsTable extends StatelessWidget {
  final ValueNotifier<SelectedDebtor?> selectedRowNotifier;
  final ValueNotifier<int?> hoveredRowNotifier;
  final ScrollController scrollController;

  const DebtorsTable({
    super.key,
    required this.selectedRowNotifier,
    required this.hoveredRowNotifier,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegionCubit, RegionState>(
      builder: (context, regionState) {
        if (regionState is! RegionLoaded) return _buildRegionState(regionState);
        final regions = regionState.regions;

        return BlocBuilder<DebtorCubit, DebtorState>(
          builder: (context, debtorState) {
            if (debtorState is! DebtorLoaded) {
              return _buildDebtorState(debtorState);
            }
            final debtors = debtorState.debtors;

            return Column(
              children: [
                _buildHeader(), // шапка завжди зверху
                Expanded(
                  child: Scrollbar(
                    controller: scrollController,
                    thumbVisibility: true,
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: debtors.length,
                      itemBuilder: (context, index) {
                        final debtor = debtors[index];
                        return ValueListenableBuilder(
                          valueListenable: hoveredRowNotifier,
                          builder: (context, hoveredIndex, _) {
                            final isHovered = hoveredIndex == index;
                            return ValueListenableBuilder<SelectedDebtor?>(
                              valueListenable: selectedRowNotifier,
                              builder: (context, _, _) {
                                final isSelected =
                                    selectedRowNotifier.value?.index;

                                return MouseRegion(
                                  onEnter: (_) {
                                    if (selectedRowNotifier.value?.index !=
                                        index) {
                                      hoveredRowNotifier.value = index;
                                    }
                                  },
                                  onExit: (_) {
                                    if (selectedRowNotifier.value?.index !=
                                        index) {
                                      hoveredRowNotifier.value = null;
                                    }
                                  },
                                  child: GestureDetector(
                                    onTap: () {
                                      selectedRowNotifier.value =
                                          SelectedDebtor(
                                            debtor: debtor,
                                            index: index,
                                          );
                                      final rowContext = context;
                                    },
                                    child: Container(
                                      decoration: _rowDecoration(
                                        index,
                                        isSelected,
                                        isHovered,
                                      ),

                                      padding: const EdgeInsets.symmetric(
                                        vertical: 6,
                                        horizontal: 8,
                                      ),
                                      child: Row(
                                        children: [
                                          _cell((index + 1).toString(), 40),
                                          _cell(debtor.fullName, 200),
                                          _cell(debtor.decree, 120),
                                          _cell(debtor.amount, 80),
                                          _cell(debtor.address, 220),
                                          _regionCell(
                                            context,
                                            debtor,
                                            regions,
                                            200,
                                          ),
                                          _executorCell(
                                            context,
                                            debtor,
                                            regions,
                                            300,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Color _rowColor(int index, int? selectedIndex) {
    if (selectedIndex == index) return Colors.blue.withOpacity(0.3);

    return index % 2 == 0 ? Colors.white : Colors.grey[200]!;
  }

  BoxDecoration _rowDecoration(int index, int? selectedIndex, bool isHovered) {
    if (selectedIndex == index) {
      return BoxDecoration(
        color: Colors.blue[300],
        boxShadow: isHovered
            ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            offset: Offset(0, -3), // тінь зверху
            blurRadius: 6,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            offset: Offset(0, 3), // тінь знизу
            blurRadius: 6,
          ),
        ]
            : [],
      );
    }

    return BoxDecoration(
      color: Colors.white,
      boxShadow: isHovered
          ? [
        BoxShadow(
          color: Colors.black.withOpacity(0.25),
          offset: Offset(0, -3),
          blurRadius: 6,
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.25),
          offset: Offset(0, 3),
          blurRadius: 6,
        ),
      ]
          : [],
    );
  }


  Widget _buildRegionState(RegionState state) {
    if (state is RegionLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is RegionError) {
      return Center(child: Text('Помилка: ${state.message}'));
    }
    return const SizedBox.shrink();
  }

  Widget _buildDebtorState(DebtorState state) {
    if (state is DebtorLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is DebtorError) {
      return Center(child: Text('Помилка: ${state.message}'));
    }
    return const SizedBox.shrink();
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryMainBlue,

        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: Row(
        children: [
          _headerCell('№', 40),
          _headerCell('ПІБ', 200),
          _headerCell('Постанова', 120),
          _headerCell('Сума', 80),
          _headerCell('Адреса', 220),
          _headerCell('Область', 200),
          _headerCell('Виконавець', 300),
        ],
      ),
    );
  }

  Widget _cell(String text, double width) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 12),
      ),
    );
  }

  Widget _headerCell(String text, double width) {
    return SizedBox(
      width: width,
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: AppColors.primaryWhite,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _regionCell(
    BuildContext context,
    DebtorEntity debtor,
    List<RegionEntity> regions,
    double width,
  ) {
    final currentRegion = regions.firstWhere(
      (r) => r.id == debtor.regionId,
      orElse: () =>
          const RegionEntity(id: 0, name: 'не вибрано', executorOffices: []),
    );

    return GestureDetector(
      onTap: () async {
        final selected = await showDialog<RegionEntity>(
          context: context,
          builder: (cntx) => SimpleDialog(
            backgroundColor: Colors.white,
            title: const Text('Оберіть область'),
            children: regions
                .map(
                  (r) => SimpleDialogOption(
                    child: Text(r.name),
                    onPressed: () => Navigator.pop(cntx, r),
                  ),
                )
                .toList(),
          ),
        );
        if (selected != null) {
          final primaryExecutor = selected.executorOffices.firstWhere(
            (e) => e.isPrimary,
            orElse: () => const ExecutorEntity(
              id: 0,
              name: '',
              address: '',
              isPrimary: false,
              regionId: 0,
            ),
          );
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<DebtorCubit>().updateDebtor(
              debtor.copyWith(
                regionId: selected.id == 0 ? null : selected.id,
                executorId: primaryExecutor.id == 0 ? null : primaryExecutor.id,
              ),
            );
          });
        }
      },
      child: Container(
        padding: EdgeInsets.all(8),
        width: width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(currentRegion.name, style: const TextStyle(fontSize: 12)),
            Icon(Icons.keyboard_arrow_down_outlined),
          ],
        ),
      ),
    );
  }

  Widget _executorCell(
    BuildContext context,
    DebtorEntity debtor,
    List<RegionEntity> regions,
    double width,
  ) {
    final executors = debtor.regionId != null
        ? regions
              .firstWhere(
                (r) => r.id == debtor.regionId,
                orElse: () =>
                    const RegionEntity(id: 0, name: '', executorOffices: []),
              )
              .executorOffices
        : <ExecutorEntity>[];

    final currentExecutor = executors.firstWhere(
      (e) => e.id == debtor.executorId,
      orElse: () => const ExecutorEntity(
        id: 0,
        name: 'не вибрано',
        address: '',
        isPrimary: false,
        regionId: 0,
      ),
    );

    return GestureDetector(
      onTap: () async {
        final selected = await showDialog<ExecutorEntity>(
          context: context,
          builder: (cntx) => SimpleDialog(
            backgroundColor: Colors.white,

            title: const Text('Оберіть виконавця'),
            children: executors
                .map(
                  (e) => SimpleDialogOption(
                    child: Text(e.name),
                    onPressed: () => Navigator.pop(cntx, e),
                  ),
                )
                .toList(),
          ),
        );
        if (selected != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<DebtorCubit>().updateDebtor(
              debtor.copyWith(
                executorId: selected.id == 0 ? null : selected.id,
              ),
            );
          });
        }
      },

      child: Container(
        width: width,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: currentExecutor.id == 0 ? Colors.red.shade100 : null,
          border: Border.all(
            color: currentExecutor.id == 0 ? Colors.red : Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Flexible(
              child: SizedBox(
                width: width - 30,
                child: Text(
                  currentExecutor.name,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),

            Icon(Icons.keyboard_arrow_down_outlined),
          ],
        ),
      ),
    );
  }
}

class SelectedDebtor {
  final DebtorEntity debtor;
  final int index;

  const SelectedDebtor({required this.debtor, required this.index});
}
