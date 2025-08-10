import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/debtor_entity.dart';
import '../../domain/entities/executor_office_entity.dart';
import '../../domain/entities/region_entity.dart';
import '../blocs/debtor_cubit.dart';
import '../blocs/executor_office_cubit.dart';
import '../blocs/folder_cubit.dart';
import '../blocs/panels_cubit.dart';
import '../blocs/region_cubit.dart';

class MainPanel extends StatelessWidget {
  const MainPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final folderPath = context.watch<FolderCubit>().state;

    return Scaffold(
      appBar: AppBar(title: const Text('Перегляд документів')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 📁 Шлях до папки в рамці
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      folderPath ?? 'Папку не вибрано',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _selectFolder(context),
                    child: const Text('Вибрати папку'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// ➕ Кнопка додавання регіонів
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                onPressed: () =>
                    context.read<PanelsCubit>().toggleRegionPanel(),
                child: const Text('Додати регіони'),
              ),
            ),

            const SizedBox(height: 16),

            /// ➕ Кнопка додавання боржника
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                onPressed: () => showAddDebtorDialog(context),
                child: const Text('Додати боржника'),
              ),
            ),

            const SizedBox(height: 24),

            /// 📄 Таблиця з рамкою
            const Text(
              'Документи',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(8),
                child: const DebtorsTable(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _selectFolder(BuildContext context) async {
  final folderCubit = context.read<FolderCubit>(); // зберігаємо до await
  final result = await FilePicker.platform.getDirectoryPath();
  if (result != null) {
    folderCubit.setFolder(result);
  }
}

class DebtorsTable extends StatelessWidget {
  const DebtorsTable({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegionCubit, List<RegionEntity>>(
      builder: (context, regions) {
        return BlocBuilder<ExecutorOfficeCubit, List<ExecutorOfficeEntity>>(
          builder: (context, executors) {
            return BlocBuilder<DebtorCubit, List<DebtorEntity>>(
              builder: (context, debtors) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('ПІБ')),
                      DataColumn(label: Text('Постанова')),
                      DataColumn(label: Text('Сума')),
                      DataColumn(label: Text('Область')),
                      DataColumn(label: Text('Виконавець')),
                    ],
                    rows: debtors.map((debtor) {
                      return DataRow(cells: [
                        DataCell(Text(debtor.fullName ?? '')),
                        DataCell(Text(debtor.decree ?? '')),
                        DataCell(Text(debtor.amount ?? '')),
                        DataCell(
                          DropdownButton<String>(
                            value:
                            _regionNameById(regions, debtor.regionId) ??
                                'не вибрано',
                            items: [
                              const DropdownMenuItem(
                                value: 'не вибрано',
                                child: Text('не вибрано'),
                              ),
                              ...regions.map((r) => DropdownMenuItem(
                                value: r.name,
                                child: Text(r.name),
                              )),
                            ],
                            onChanged: (value) {
                              final selectedRegion = regions.firstWhere(
                                    (r) => r.name == value,
                                orElse: () =>
                                    RegionEntity(id: 0, name: ''),
                              );
                              final newRegionId =
                              selectedRegion.id == 0 ? null : selectedRegion.id;
                              final updatedDebtor =
                              debtor.copyWith(regionId: newRegionId);
                              context
                                  .read<DebtorCubit>()
                                  .updateDebtor(updatedDebtor);
                            },
                          ),
                        ),
                        DataCell(
                          DropdownButton<String>(
                            value: _executorNameById(
                                executors, debtor.executorId) ??
                                'не вибрано',
                            items: [
                              const DropdownMenuItem(
                                value: 'не вибрано',
                                child: Text('не вибрано'),
                              ),
                              ...executors.map((e) => DropdownMenuItem(
                                value: e.name,
                                child: Text(e.name),
                              )),
                            ],
                            onChanged: (value) {
                              final selectedExecutor = executors.firstWhere(
                                    (e) => e.name == value,
                                orElse: () =>
                                    ExecutorOfficeEntity(
                                      id: 0,
                                      name: '',
                                      address: '',
                                      isPrimary: false,
                                      regionId: 0,
                                    ),
                              );
                              final newExecutorId =
                              selectedExecutor.id == 0 ? null : selectedExecutor.id;
                              final updatedDebtor =
                              debtor.copyWith(executorId: newExecutorId);
                              context
                                  .read<DebtorCubit>()
                                  .updateDebtor(updatedDebtor);
                            },
                          ),
                        ),
                      ]);
                    }).toList(),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

String? _regionNameById(List<RegionEntity> regions, int? regionId) {
  if (regionId == null) return null;
  final region = regions.firstWhere(
        (r) => r.id == regionId,
    orElse: () => RegionEntity(id: 0, name: ''),
  );
  return region.name.isEmpty ? null : region.name;
}

String? _executorNameById(List<ExecutorOfficeEntity> executors, int? executorId) {
  if (executorId == null) return null;
  final executor = executors.firstWhere(
        (e) => e.id == executorId,
    orElse: () =>
        ExecutorOfficeEntity(id: 0, name: '', address: '', isPrimary: false, regionId: 0),
  );
  return executor.name.isEmpty ? null : executor.name;
}

Future<void> showAddDebtorDialog(BuildContext context) async {
  final fullNameController = TextEditingController();
  final decreeController = TextEditingController();
  final amountController = TextEditingController();
  final addressController = TextEditingController();

  final regions = context.read<RegionCubit>().state;
  final executors = context.read<ExecutorOfficeCubit>().state;

  int? selectedRegionId;
  int? selectedExecutorId;

  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Додати боржника'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: fullNameController,
                decoration: const InputDecoration(labelText: 'ПІБ'),
              ),
              TextField(
                controller: decreeController,
                decoration: const InputDecoration(labelText: 'Постанова'),
              ),
              TextField(
                controller: amountController,
                decoration: const InputDecoration(labelText: 'Сума'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Адреса'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: 'Область'),
                value: selectedRegionId,
                items: [
                  const DropdownMenuItem<int>(
                    value: null,
                    child: Text('не вибрано'),
                  ),
                  ...regions.map((r) => DropdownMenuItem<int>(
                    value: r.id,
                    child: Text(r.name),
                  )),
                ],
                onChanged: (value) {
                  selectedRegionId = value;
                },
              ),
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: 'Виконавець'),
                value: selectedExecutorId,
                items: [
                  const DropdownMenuItem<int>(
                    value: null,
                    child: Text('не вибрано'),
                  ),
                  ...executors.map((e) => DropdownMenuItem<int>(
                    value: e.id,
                    child: Text(e.name),
                  )),
                ],
                onChanged: (value) {
                  selectedExecutorId = value;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Скасувати'),
          ),
          ElevatedButton(
            onPressed: () {
              final newDebtor = DebtorEntity(
                id: 0,
                fullName: fullNameController.text.trim(),
                decree: decreeController.text.trim(),
                amount: amountController.text.trim(),
                address: addressController.text.trim(),
                regionId: selectedRegionId,
                executorId: selectedExecutorId,
              );
              context.read<DebtorCubit>().addDebtor(newDebtor);
              Navigator.of(context).pop();
            },
            child: const Text('Додати'),
          ),
        ],
      );
    },
  );
}
