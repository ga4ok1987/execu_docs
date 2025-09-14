import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:execu_docs/core/constants/index.dart';
import '../../domain/entities/debtor_entity.dart';
import '../../domain/entities/executor_entity.dart';
import '../../domain/entities/region_entity.dart';
import '../blocs/debtor_cubit.dart';
import '../blocs/debtor_sort_cubit.dart';
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
            List<DebtorEntity>? debtors = [];

            if (debtorState is DebtorLoaded) {
              debtors = debtorState.debtors;

            } else {
              // інші випадки
              return _buildDebtorState(debtorState);
            }

            return Center(
              child: SizedBox(
                width: AppSizes.tableWidth,
                child: Column(
                  children: [
                    _buildHeader(context), // шапка з сортуванням
                    Expanded(
                      child: BlocBuilder<DebtorSortCubit, DebtorSortState>(
                        builder: (context, sortState) {
                          final sortedDebtors = List<DebtorEntity>.from(debtors!)
                            ..sort((a, b) {
                              final valA = _getColumnValue(a, sortState.column);
                              final valB = _getColumnValue(b, sortState.column);
                              if (valA is num && valB is num) {
                                return sortState.ascending
                                    ? valA.compareTo(valB)
                                    : valB.compareTo(valA);
                              }
                              return sortState.ascending
                                  ? valA.toString().compareTo(valB.toString())
                                  : valB.toString().compareTo(valA.toString());
                            });

                          return Scrollbar(
                            controller: scrollController,
                            thumbVisibility: true,
                            child: ListView.builder(
                              controller: scrollController,
                              itemCount: sortedDebtors.length,
                              itemBuilder: (context, index) {
                                final debtor = sortedDebtors[index];
                                return ValueListenableBuilder(
                                  valueListenable: hoveredRowNotifier,
                                  builder: (context, hoveredIndex, _) {
                                    final isHovered = hoveredIndex == index;
                                    return ValueListenableBuilder<
                                      SelectedDebtor?
                                    >(
                                      valueListenable: selectedRowNotifier,
                                      builder: (context, _, __) {
                                        final isSelected =
                                            selectedRowNotifier.value?.index;
                                        return MouseRegion(
                                          onEnter: (_) {
                                            if (selectedRowNotifier
                                                    .value
                                                    ?.index !=
                                                index) {
                                              hoveredRowNotifier.value = index;
                                            }
                                          },
                                          onExit: (_) {
                                            if (selectedRowNotifier
                                                    .value
                                                    ?.index !=
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
                                            },
                                            child: Container(
                                              decoration: _rowDecoration(
                                                index,
                                                isSelected,
                                                isHovered,
                                              ),
                                              padding: AppPadding.hor8ver6,
                                              child: Row(
                                                children: [
                                                  _cell(
                                                    (index + 1).toString(),
                                                    AppSizes
                                                        .columnWidths[AppTexts
                                                        .number]!,
                                                  ),
                                                  _cell(
                                                    debtor.fullName,
                                                    AppSizes
                                                        .columnWidths[AppTexts
                                                        .fullName]!,
                                                  ),
                                                  _cell(
                                                    debtor.decree,
                                                    AppSizes
                                                        .columnWidths[AppTexts
                                                        .decree]!,
                                                  ),
                                                  _cell(
                                                    debtor.amount,
                                                    AppSizes
                                                        .columnWidths[AppTexts
                                                        .amount]!,
                                                  ),
                                                  _cell(
                                                    debtor.address,
                                                    AppSizes
                                                        .columnWidths[AppTexts
                                                        .address]!,
                                                  ),
                                                  _regionCell(
                                                    context,
                                                    debtor,
                                                    regions,
                                                    AppSizes
                                                        .columnWidths[AppTexts
                                                        .region]!,
                                                  ),
                                                  _executorCell(
                                                    context,
                                                    debtor,
                                                    regions,
                                                    AppSizes
                                                        .columnWidths[AppTexts
                                                        .executor]!,
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
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  BoxDecoration _rowDecoration(int index, int? selectedIndex, bool isHovered) {
    if (selectedIndex == index) {
      return BoxDecoration(color: AppColors.primaryLightMain);
    }

    return BoxDecoration(
      color: AppColors.primaryWhite,

      gradient: isHovered
          ? LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: AppColors.gradientWhite,
            )
          : null,
    );
  }

  Widget _buildRegionState(RegionState state) {
    if (state is RegionLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is RegionError) {
      return Center(child: Text(AppTexts.errorString(state.message)));
    }
    return const SizedBox.shrink();
  }

  Widget _buildDebtorState(DebtorState state) {
    if (state is DebtorLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is DebtorError) {
      return Center(child: Text(AppTexts.errorString(state.message)));
    }
    return const SizedBox.shrink();
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryMainBlue,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: Row(
        children: AppSizes.columnWidths.entries.map((e) {
          return GestureDetector(
            onTap: () {
              context.read<DebtorSortCubit>().toggleColumn(e.key);
              selectedRowNotifier.value = null;
              },
            child: SizedBox(
              width: e.value,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      e.key,
                      style: const TextStyle(
                        color: AppColors.primaryWhite,
                        fontWeight: FontWeight.bold,
                        fontSize: AppTextSizes.small,
                      ),
                    ),
                    BlocBuilder<DebtorSortCubit, DebtorSortState>(
                      builder: (context, sortState) {
                        if (sortState.column != e.key) {
                          return const SizedBox.shrink();
                        }
                        return Icon(
                          sortState.ascending
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                          size: 14,
                          color: AppColors.primaryWhite,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  dynamic _getColumnValue(DebtorEntity debtor, String column) {
    switch (column) {
      case AppTexts.number:
        return debtor.id;
      case AppTexts.fullName:
        return debtor.fullName;
      case AppTexts.decree:
        return debtor.decree;
      case AppTexts.amount:
        return debtor.amount;
      case AppTexts.address:
        return debtor.address;
      case AppTexts.region:
        return debtor.regionId ?? 0;
      case AppTexts.executor:
        return debtor.executorId ?? 0;
      default:
        return AppTexts.empty;
    }
  }

  Widget _cell(String text, double width) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: AppTextSizes.small),
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
      orElse: () => const RegionEntity(
        id: 0,
        name: AppTexts.notSelected,
        executorOffices: [],
      ),
    );

    return GestureDetector(
      onTap: () async {
        final selected = await showDialog<RegionEntity>(
          context: context,
          builder: (cntx) => SimpleDialog(
            backgroundColor: AppColors.primaryWhite,
            title: const Text(AppTexts.selectRegion),
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
              name: AppTexts.empty,
              address: AppTexts.empty,
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
        padding: AppPadding.all8,
        width: width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              currentRegion.name,
              style: const TextStyle(fontSize: AppTextSizes.small),
            ),
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
                orElse: () => const RegionEntity(
                  id: 0,
                  name: AppTexts.empty,
                  executorOffices: [],
                ),
              )
              .executorOffices
        : <ExecutorEntity>[];

    final currentExecutor = executors.firstWhere(
      (e) => e.id == debtor.executorId,
      orElse: () => const ExecutorEntity(
        id: 0,
        name: AppTexts.notSelected,
        address: AppTexts.empty,
        isPrimary: false,
        regionId: 0,
      ),
    );

    return GestureDetector(
      onTap: () async {
        final selected = await showDialog<ExecutorEntity>(
          context: context,
          builder: (cntx) => SimpleDialog(
            backgroundColor: AppColors.primaryWhite,

            title: const Text(AppTexts.selectExecutor),
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
        padding: AppPadding.all8,
        decoration: BoxDecoration(
          color: currentExecutor.id == 0 ? AppColors.notSelected : null,
          border: Border.all(
            color: currentExecutor.id == 0
                ? AppColors.errorMain
                : AppColors.transparent,
          ),
          borderRadius: AppBorderRadius.all4,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                currentExecutor.name,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                style: const TextStyle(fontSize: AppTextSizes.small),
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
