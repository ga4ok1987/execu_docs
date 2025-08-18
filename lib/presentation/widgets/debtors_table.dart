import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/debtor_entity.dart';
import '../../domain/entities/executor_entity.dart';
import '../../domain/entities/region_entity.dart';
import '../blocs/debtor_cubit.dart';
import '../blocs/region_cubit.dart';

class DebtorsTable extends StatelessWidget {
  final ValueNotifier<List<int>?> selectedRowNotifier; // для вибору рядка
  final List<ValueNotifier<bool>> hoverNotifiers; // для hover-ефекту

  DebtorsTable({
    super.key,
    required this.selectedRowNotifier,
    required int rowCount,
  }) : hoverNotifiers = List.generate(
         rowCount,
         (_) => ValueNotifier<bool>(false),
       );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegionCubit, RegionState>(
      builder: (context, regionState) {
        if (regionState is RegionLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (regionState is RegionError) {
          return Center(child: Text('Помилка: ${regionState.message}'));
        } else if (regionState is RegionLoaded) {
          final regions = regionState.regions;

          return BlocBuilder<DebtorCubit, DebtorState>(
            builder: (context, debtorState) {
              if (debtorState is DebtorLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (debtorState is DebtorError) {
                return Center(child: Text('Помилка: ${debtorState.message}'));
              } else if (debtorState is DebtorLoaded) {
                final debtors = debtorState.debtors;

                return LayoutBuilder(
                  builder: (context, constraints) {
                    final totalWidth = constraints.maxWidth;
                    final colWidths = [
                      totalWidth * 0.02, // №
                      totalWidth * 0.15, // ПІБ
                      totalWidth * 0.1, // Постанова
                      totalWidth * 0.06, // Сума
                      totalWidth * 0.2, // Адреса
                      totalWidth * 0.24, // Область
                      totalWidth * 0.24, // Виконавець
                    ];

                    return ValueListenableBuilder<List<int>?>(
                      valueListenable: selectedRowNotifier,
                      builder: (context, selectedIndex, _) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: SizedBox(
                              width: totalWidth,
                              child: DataTable(
                                columnSpacing: 0,
                                headingRowHeight: 28,
                                columns: [
                                  _col('№', colWidths[0]),
                                  _col('ПІБ', colWidths[1]),
                                  _col('Постанова', colWidths[2]),
                                  _col('Сума', colWidths[3]),
                                  _col('Адреса', colWidths[4]),
                                  _col('Область', 210),
                                  _col('Виконавець', colWidths[6]),
                                ],
                                rows: List.generate(debtors.length, (index) {
                                  final debtor = debtors[index];
                                  final isEven = index % 2 == 0;

                                  return DataRow(
                                    color: WidgetStateProperty.resolveWith((
                                      states,
                                    ) {
                                      return _resolveRowColor(
                                        index,
                                        isEven,
                                        selectedIndex?[1],
                                      );
                                    }),
                                    cells: [
                                      DataCell(
                                        _wrapText(
                                          (index + 1).toString(),
                                          colWidths[0],
                                        ),
                                        onTap: () {
                                          selectedRowNotifier.value = [
                                            debtor.id,
                                            index,
                                          ];
                                        },
                                      ),
                                      DataCell(
                                        _wrapText(
                                          debtor.fullName,
                                          colWidths[1],
                                        ),
                                        onTap: () {
                                          selectedRowNotifier.value = [
                                            debtor.id,
                                            index,
                                          ];
                                        },
                                      ),
                                      DataCell(
                                        _wrapText(debtor.decree, colWidths[2]),
                                        onTap: () {
                                          selectedRowNotifier.value = [
                                            debtor.id,
                                            index,
                                          ];
                                        },
                                      ),
                                      DataCell(
                                        _wrapText(debtor.amount, colWidths[3]),
                                        onTap: () {
                                          selectedRowNotifier.value = [
                                            debtor.id,
                                            index,
                                          ];
                                        },
                                      ),
                                      DataCell(
                                        _wrapText(debtor.address, colWidths[4]),
                                        onTap: () {
                                          selectedRowNotifier.value = [
                                            debtor.id,
                                            index,
                                          ];
                                        },
                                      ),
                                      DataCell(
                                        _regionDropdown(
                                          context,
                                          regions,
                                          debtor,
                                          210,
                                        ),
                                        onTap: () {
                                          selectedRowNotifier.value = [
                                            debtor.id,
                                            index,
                                          ];
                                        },
                                      ),
                                      DataCell(
                                        _executorDropdown(
                                          context,
                                          regions,
                                          debtor,
                                          colWidths[6],
                                        ),
                                        onTap: () {
                                          selectedRowNotifier.value = [
                                            debtor.id,
                                            index,
                                          ];
                                        },
                                      ),
                                    ],
                                  );
                                }),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  // ==============================
  // Хелпери
  // ==============================

  DataColumn _col(String label, double width) {
    return DataColumn(
      label: ConstrainedBox(
        constraints: BoxConstraints(minWidth: width),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _wrapText(String text, double width) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: width),
      child: Center(
        child: Text(
          text,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          style: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }

  Color _resolveRowColor(int index, bool isEven, int? selectedIndex) {
    if (selectedIndex == index) {
      return Colors.blue.withOpacity(0.3); // виділений рядок
    }
    return isEven ? Colors.grey.shade100 : Colors.grey.shade200;
  }

  // ==============================
  // Dropdown
  // ==============================

  Widget _regionDropdown(
    BuildContext context,
    List<RegionEntity> regions,
    DebtorEntity debtor,
    double width,
  ) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        buttonStyleData: ButtonStyleData(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          height: 32,
          width: width,
        ),
        value: _regionNameById(regions, debtor.regionId) ?? 'не вибрано',
        items: [
          const DropdownMenuItem(
            value: 'не вибрано',
            child: Text(
              'не вибрано',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12),
            ),
          ),
          ...regions.map(
            (r) => DropdownMenuItem(
              value: r.name,
              child: Text(
                r.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
        ],
        onChanged: (value) {
          final selectedRegion = regions.firstWhere(
            (r) => r.name == value,
            orElse: () =>
                const RegionEntity(id: 0, name: '', executorOffices: []),
          );

          final newRegionId = selectedRegion.id == 0 ? null : selectedRegion.id;

          final primaryExecutor = selectedRegion.executorOffices.firstWhere(
            (e) => e.isPrimary,
            orElse: () => const ExecutorEntity(
              id: 0,
              name: '',
              address: '',
              isPrimary: false,
              regionId: 0,
            ),
          );

          final newExecutorId = primaryExecutor.id == 0
              ? null
              : primaryExecutor.id;

          final updatedDebtor = debtor.copyWith(
            regionId: newRegionId,
            executorId: newExecutorId,
          );
          context.read<DebtorCubit>().updateDebtor(updatedDebtor);
        },
      ),
    );
  }

  Widget _executorDropdown(
    BuildContext context,
    List<RegionEntity> regions,
    DebtorEntity debtor,
    double width,
  ) {
    final executors = _executorsByRegionId(regions, debtor.regionId);

    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        buttonStyleData: ButtonStyleData(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          height: 32,
          width: width,
        ),
        value: _executorNameById(executors, debtor.executorId) ?? 'не вибрано',
        items: [
          const DropdownMenuItem(
            value: 'не вибрано',
            child: Text('не вибрано', style: TextStyle(fontSize: 12)),
          ),
          ...executors.map(
            (e) => DropdownMenuItem(
              value: e.name,
              child: Text(e.name, style: const TextStyle(fontSize: 12)),
            ),
          ),
        ],
        onChanged: (value) {
          final selectedExecutor = executors.firstWhere(
            (e) => e.name == value,
            orElse: () => const ExecutorEntity(
              id: 0,
              name: '',
              address: '',
              isPrimary: false,
              regionId: 0,
            ),
          );

          final newExecutorId = selectedExecutor.id == 0
              ? null
              : selectedExecutor.id;

          final updatedDebtor = debtor.copyWith(executorId: newExecutorId);
          context.read<DebtorCubit>().updateDebtor(updatedDebtor);
        },
      ),
    );
  }

  String? _regionNameById(List<RegionEntity> regions, int? id) {
    if (id == null) return null;
    return regions
        .firstWhere(
          (r) => r.id == id,
          orElse: () =>
              const RegionEntity(id: 0, name: '', executorOffices: []),
        )
        .name;
  }

  String? _executorNameById(List<ExecutorEntity> executors, int? id) {
    if (id == null) return null;
    return executors
        .firstWhere(
          (e) => e.id == id,
          orElse: () => const ExecutorEntity(
            id: 0,
            name: '',
            address: '',
            isPrimary: false,
            regionId: 0,
          ),
        )
        .name;
  }

  List<ExecutorEntity> _executorsByRegionId(
    List<RegionEntity> regions,
    int? regionId,
  ) {
    if (regionId == null) return [];
    final region = regions.firstWhere(
      (r) => r.id == regionId,
      orElse: () => const RegionEntity(id: 0, name: '', executorOffices: []),
    );
    return region.executorOffices;
  }
}

class SelectedItem {
  final int regionId;
  final int index;

  SelectedItem({required this.regionId, required this.index});
}
