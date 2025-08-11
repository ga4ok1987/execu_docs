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

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('ПІБ')),
                      DataColumn(label: Text('Постанова')),
                      DataColumn(label: Text('Сума')),
                      DataColumn(label: Text('Адреса')),
                      DataColumn(label: Text('Область')),
                      DataColumn(label: Text('Виконавець')),
                    ],
                    rows: debtors.map((debtor) {
                      return DataRow(cells: [
                        DataCell(Text(debtor.fullName)),
                        DataCell(Text(debtor.decree)),
                        DataCell(Text(debtor.amount)),
                        DataCell(Text(debtor.address)),
                        DataCell(_regionDropdown(context, regions, debtor)),
                        DataCell(_executorDropdown(context, regions, debtor)),
                      ]);
                    }).toList(),
                  ),
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

  Widget _regionDropdown(BuildContext context, List<RegionEntity> regions, DebtorEntity debtor) {
    return DropdownButton<String>(
      value: _regionNameById(regions, debtor.regionId) ?? 'не вибрано',
      items: [
        const DropdownMenuItem(value: 'не вибрано', child: Text('не вибрано')),
        ...regions.map((r) => DropdownMenuItem(value: r.name, child: Text(r.name))),
      ],
      onChanged: (value) {
        final selectedRegion = regions.firstWhere(
              (r) => r.name == value,
          orElse: () => const RegionEntity(id: 0, name: '', executorOffices: []),
        );

        final newRegionId = selectedRegion.id == 0 ? null : selectedRegion.id;

        // Вибір основного виконавця з вибраного регіону
        final primaryExecutor = selectedRegion.executorOffices.firstWhere(
              (e) => e.isPrimary,
          orElse: () => const ExecutorOfficeEntity(id: 0, name: '', address: '', isPrimary: false, regionId: 0),
        );

        final newExecutorId = primaryExecutor.id == 0 ? null : primaryExecutor.id;

        final updatedDebtor = debtor.copyWith(regionId: newRegionId, executorId: newExecutorId);
        context.read<DebtorCubit>().updateDebtor(updatedDebtor);
      },
    );
  }

  Widget _executorDropdown(BuildContext context, List<RegionEntity> regions, DebtorEntity debtor) {
    final executors = _executorsByRegionId(regions, debtor.regionId);

    return DropdownButton<String>(
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
