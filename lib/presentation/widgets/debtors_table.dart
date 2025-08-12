import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/debtor_entity.dart';
import '../../domain/entities/executor_office_entity.dart';
import '../../domain/entities/region_entity.dart';
import '../blocs/debtor_cubit.dart';
import '../blocs/region_cubit.dart';

class DebtorsTable extends StatelessWidget {
  const DebtorsTable({super.key});

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
                        totalWidth * 0.15, // ПІБ
                        totalWidth * 0.01, // Постанова
                        totalWidth * 0.01,  // Сума
                        totalWidth * 0.25, // Адреса
                        totalWidth * 0.05, // Область
                        totalWidth * 0.1,  // Виконавець
                      ];
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,

                      child: DataTable(
                        dataRowColor: WidgetStateProperty.resolveWith<Color?>(
                              (Set<WidgetState> states) {
                            // Чередування кольору для парних і непарних рядків
                            int index = states.contains(WidgetState.selected) ? 0 : -1;
                            if (index == -1) return null; // default

                            // Але DataTable не передає індекс, тому робимо трюк нижче
                            return null; // стандартний, нижче реалізуємо в rows
                          },
                        ),
                        columns: [
                          DataColumn(label: SizedBox(width: colWidths[0], child: const Text('ПІБ'))),
                          DataColumn(label: SizedBox(width: colWidths[1], child: const Text('Постанова'))),
                          DataColumn(label: SizedBox(width: colWidths[2], child: const Text('Сума'))),
                          DataColumn(label: SizedBox(width: colWidths[3], child: const Text('Адреса'))),
                          DataColumn(label: SizedBox(width: colWidths[4], child: const Text('Область'))),
                          DataColumn(label: SizedBox(width: colWidths[5], child: const Text('Виконавець'))),
                        ],
                        rows: List<DataRow>.generate(
                          debtors.length,
                              (index) {
                            final debtor = debtors[index];
                            final isEven = index % 2 == 0;

                            return DataRow(
                              color: WidgetStateProperty.all(
                                isEven ? Colors.grey.shade100 : Colors.grey.shade200,
                              ),
                              cells: [
                                DataCell(SizedBox(width: colWidths[0], child: _buildWrappedText(debtor.fullName))),
                                DataCell(SizedBox(width: colWidths[1], child: _buildWrappedText(debtor.decree))),
                                DataCell(SizedBox(width: colWidths[2], child: _buildWrappedText(debtor.amount))),
                                DataCell(SizedBox(width: colWidths[3], child: _buildWrappedText(debtor.address))),
                                DataCell(SizedBox(width: colWidths[4], child: _regionDropdown(context, regions, debtor))),
                                DataCell(SizedBox(width: colWidths[5], child: _executorDropdown(context, regions, debtor))),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  );}
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

  Widget _buildWrappedText(String text) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 150),
      child: Text(
        text,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        softWrap: true,
        style: const TextStyle(
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _regionDropdown(BuildContext context, List<RegionEntity> regions, DebtorEntity debtor) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        buttonStyleData: ButtonStyleData(width: MediaQuery.of(context).size.width),
        iconStyleData: IconStyleData(icon: SizedBox.shrink()),
        isExpanded: true,  // щоб випадаюче меню розтягувалось по ширині контейнера

        value: _regionNameById(regions, debtor.regionId) ?? 'не вибрано',
        items: [
          const DropdownMenuItem<String>(
            value: 'не вибрано',
            child: Text(
              'не вибрано',
              softWrap: true,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12),
            ),
          ),
          ...regions.map(
                (r) => DropdownMenuItem<String>(
              value: r.name,
              child: Text(
                r.name,
                softWrap: true,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
        ],
        selectedItemBuilder: (context) {
          return [
            const Text(
              'не вибрано',
              softWrap: true,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12, color: Colors.black87),
            ),
            ...regions.map((r) => Text(
              r.name,
              softWrap: true,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, color: Colors.black87),
            )),
          ];
        },
        onChanged: (value) {
          final selectedRegion = regions.firstWhere(
                (r) => r.name == value,
            orElse: () => const RegionEntity(id: 0, name: '', executorOffices: []),
          );

          final newRegionId = selectedRegion.id == 0 ? null : selectedRegion.id;

          final primaryExecutor = selectedRegion.executorOffices.firstWhere(
                (e) => e.isPrimary,
            orElse: () => const ExecutorOfficeEntity(id: 0, name: '', address: '', isPrimary: false, regionId: 0),
          );

          final newExecutorId = primaryExecutor.id == 0 ? null : primaryExecutor.id;

          final updatedDebtor = debtor.copyWith(regionId: newRegionId, executorId: newExecutorId);
          context.read<DebtorCubit>().updateDebtor(updatedDebtor);
        },
      ),
    );
  }


  Widget _executorDropdown(BuildContext context, List<RegionEntity> regions, DebtorEntity debtor) {
    final executors = _executorsByRegionId(regions, debtor.regionId);

    return DropdownButtonHideUnderline(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8),
        ),
        child: DropdownButton<String>(
          isDense: true,
          style: const TextStyle(fontSize: 12, color: Colors.black87),
          value: _executorNameById(executors, debtor.executorId) ?? 'не вибрано',
          items: [
            const DropdownMenuItem(value: 'не вибрано', child: Text('не вибрано')),
            ...executors.map((e) => DropdownMenuItem(value: e.name, child: Text(e.name))),
          ],
          onChanged: (value) {
            final selectedExecutor = executors.firstWhere(
                  (e) => e.name == value,
              orElse: () => const ExecutorOfficeEntity(id: 0, name: '', address: '', isPrimary: false, regionId: 0),
            );

            final newExecutorId = selectedExecutor.id == 0 ? null : selectedExecutor.id;

            final updatedDebtor = debtor.copyWith(executorId: newExecutorId);
            context.read<DebtorCubit>().updateDebtor(updatedDebtor);
          },
        ),
      ),
    );
  }


  String? _regionNameById(List<RegionEntity> regions, int? id) {
    if (id == null) return null;
    return regions.firstWhere(
          (r) => r.id == id,
      orElse: () => const RegionEntity(id: 0, name: '', executorOffices: []),
    ).name;
  }

  String? _executorNameById(List<ExecutorOfficeEntity> executors, int? id) {
    if (id == null) return null;
    return executors.firstWhere(
          (e) => e.id == id,
      orElse: () => const ExecutorOfficeEntity(id: 0, name: '', address: '', isPrimary: false, regionId: 0),
    ).name;
  }

  List<ExecutorOfficeEntity> _executorsByRegionId(List<RegionEntity> regions, int? regionId) {
    if (regionId == null) return [];
    final region = regions.firstWhere(
          (r) => r.id == regionId,
      orElse: () => const RegionEntity(id: 0, name: '', executorOffices: []),
    );
    return region.executorOffices;
  }
}
