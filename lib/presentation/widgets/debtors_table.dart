import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/debtor_entity.dart';
import '../../domain/entities/executor_entity.dart';
import '../../domain/entities/region_entity.dart';
import '../blocs/debtor_cubit.dart';
import '../blocs/region_cubit.dart';

class DebtorsTable extends StatelessWidget {
  final ValueNotifier<SelectedDebtor?> selectedRowNotifier;

  DebtorsTable({
    super.key,
    required this.selectedRowNotifier,
    required int rowCount,
  }) : hoverNotifiers = List.generate(
         rowCount,
         (_) => ValueNotifier<bool>(false),
       );

  final List<ValueNotifier<bool>> hoverNotifiers;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegionCubit, RegionState>(
      builder: (context, regionState) {
        if (regionState is RegionLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (regionState is RegionError) {
          return Center(child: Text('Помилка: ${regionState.message}'));
        }
        if (regionState is RegionLoaded) {
          final regions = regionState.regions;

          return BlocBuilder<DebtorCubit, DebtorState>(
            builder: (context, debtorState) {
              if (debtorState is DebtorLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (debtorState is DebtorError) {
                return Center(child: Text('Помилка: ${debtorState.message}'));
              }
              if (debtorState is DebtorLoaded) {
                final debtors = debtorState.debtors;

                return LayoutBuilder(
                  builder: (context, constraints) {
                    final totalWidth = constraints.maxWidth;
                    final colWidths = [
                      totalWidth * 0.02,
                      totalWidth * 0.15,
                      totalWidth * 0.1,
                      totalWidth * 0.06,
                      totalWidth * 0.2,
                      totalWidth * 0.24,
                      totalWidth * 0.24,
                    ];

                    return ValueListenableBuilder<SelectedDebtor?>(
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
                                        selectedIndex,
                                      );
                                    }),
                                    cells: [
                                      DataCell(
                                        _wrapText(
                                          (index + 1).toString(),
                                          colWidths[0],
                                        ),
                                        onTap: () =>
                                            _selectDebtor(debtor, index),
                                      ),
                                      DataCell(
                                        _wrapText(
                                          debtor.fullName,
                                          colWidths[1],
                                        ),
                                        onTap: () =>
                                            _selectDebtor(debtor, index),
                                      ),
                                      DataCell(
                                        _wrapText(debtor.decree, colWidths[2]),
                                        onTap: () =>
                                            _selectDebtor(debtor, index),
                                      ),
                                      DataCell(
                                        _wrapText(debtor.amount, colWidths[3]),
                                        onTap: () =>
                                            _selectDebtor(debtor, index),
                                      ),
                                      DataCell(
                                        _wrapText(debtor.address, colWidths[4]),
                                        onTap: () =>
                                            _selectDebtor(debtor, index),
                                      ),
                                      DataCell(
                                        _regionDropdown(
                                          context,
                                          regions,
                                          debtor,
                                          210,
                                        ),
                                        onTap: () =>
                                            _selectDebtor(debtor, index),
                                      ),
                                      DataCell(
                                        _executorDropdown(
                                          context,
                                          regions,
                                          debtor,
                                          colWidths[6],
                                        ),
                                        onTap: () =>
                                            _selectDebtor(debtor, index),
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

  void _selectDebtor(DebtorEntity debtor, int index) {
    selectedRowNotifier.value = SelectedDebtor(debtor: debtor, index: index);
  }

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
          style: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }

  Color _resolveRowColor(int index, bool isEven, SelectedDebtor? selected) {
    if (selected?.index == index) return Colors.blue.withOpacity(0.3);
    return isEven ? Colors.grey.shade100 : Colors.grey.shade200;
  }

  // ==============================
  // Dropdown захист від неіснуючого значення
  // ==============================
  Widget _regionDropdown(
    BuildContext context,
    List<RegionEntity> regions,
    DebtorEntity debtor,
    double width,
  ) {
    final region = regions.firstWhere(
      (r) => r.id == debtor.regionId,
      orElse: () =>
          const RegionEntity(id: 0, name: 'не вибрано', executorOffices: []),
    );

    final regionName = region.id == 0 ? 'не вибрано' : region.name;

    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        value: regionName,
        buttonStyleData: ButtonStyleData(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          height: 32,
          width: width,
        ),
        items: [
          const DropdownMenuItem(
            value: 'не вибрано',
            child: Text('не вибрано', style: TextStyle(fontSize: 12)),
          ),
          ...regions.map(
            (r) => DropdownMenuItem(
              value: r.name,
              child: Text(r.name, style: const TextStyle(fontSize: 12)),
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

          context.read<DebtorCubit>().updateDebtor(
            debtor.copyWith(regionId: newRegionId, executorId: newExecutorId),
          );
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
    final executors = debtor.regionId != null
        ? regions
              .firstWhere(
                (r) => r.id == debtor.regionId,
                orElse: () =>
                    const RegionEntity(id: 0, name: '', executorOffices: []),
              )
              .executorOffices
        : <ExecutorEntity>[];

    final currentValue = executors.any((e) => e.id == debtor.executorId)
        ? executors.firstWhere((e) => e.id == debtor.executorId).name
        : 'не вибрано';

    final isNotSelected = currentValue == 'не вибрано';

    return Container(
      decoration: BoxDecoration(
        color: isNotSelected ? Colors.red.shade100 : null,
        border: Border.all(
          color: isNotSelected ? Colors.red : Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isExpanded: true,
          value: currentValue,
          buttonStyleData: ButtonStyleData(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            height: 32,
            width: width,
          ),
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
            context.read<DebtorCubit>().updateDebtor(
              debtor.copyWith(executorId: newExecutorId),
            );
          },
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
