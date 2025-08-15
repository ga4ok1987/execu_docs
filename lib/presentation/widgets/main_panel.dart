import 'package:execu_docs/core/utils/extensions.dart';
import 'package:execu_docs/core/widgets/hover_button.dart';
import 'package:execu_docs/presentation/widgets/custom_expansion_tile.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/debtor_entity.dart';
import '../../domain/entities/executor_office_entity.dart';
import '../../domain/entities/region_entity.dart';
import '../blocs/debtor_cubit.dart';
import '../blocs/folder_cubit.dart';
import '../blocs/panels_cubit.dart';
import '../blocs/region_cubit.dart';
import 'debtors_table.dart';

class MainPanel extends StatelessWidget {
  const MainPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final folderPath = context.watch<FolderCubit>().state;

    return Scaffold(
      body: SafeArea(
        child: Container(

          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              HighlightContainer(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: const Text(
                            'Підготовка документів для подання до виконавчих органів',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      HoverButton(
                        onPressed: () =>
                            context.read<PanelsCubit>().toggleRegionPanel(),
                        child: const Text('Виконавчі'),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width/2,

              child: HighlightContainer(
                  child: CustomExpansionTile(

                    title: "Налаштування",
                    expandedNotifier: settingsExpanded,

                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Шлях до папки вихідних документів:'),
                          Row(

                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    (folderPath ?? 'Папку не вибрано').shortenFolderPath(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 20),

                              HoverButton(
                                onPressed: () => _selectFolder(context),
                                child: const Text('Вибрати папку'),
                              ),
                              SizedBox(width: 10),
                            ],
                          ),
                          Text('Шлях до папки результатів:'),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                (folderPath ?? 'Папку не вибрано').shortenFolderPath(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          HoverButton(
                            onPressed: () => _selectFolder(context),
                            child: const Text('Вибрати папку'),
                          ),
                          SizedBox(width: 10),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
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
      ),
    );
  }
}

class HighlightContainer extends StatelessWidget {
  final Widget child;

  const HighlightContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(9),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

Future<void> _selectFolder(BuildContext context) async {
  final folderCubit = context.read<FolderCubit>();
  final result = await FilePicker.platform.getDirectoryPath();
  if (result != null) {
    folderCubit.setFolder(result);
  }
}

void showAddDebtorDialog(BuildContext context) {
  final fullNameController = TextEditingController();
  final decreeController = TextEditingController();
  final amountController = TextEditingController();
  final addressController = TextEditingController();

  final regions = context.read<RegionCubit>().state is RegionLoaded
      ? (context.read<RegionCubit>().state as RegionLoaded).regions
      : <RegionEntity>[];

  int? selectedRegionId;
  int? selectedExecutorId;
  List<ExecutorOfficeEntity> executors = [];

  showDialog(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          // Оновлення виконавців при виборі регіону
          if (selectedRegionId != null) {
            final selectedRegion = regions.firstWhere(
              (r) => r.id == selectedRegionId,
              orElse: () => RegionEntity(id: 0, name: '', executorOffices: []),
            );
            executors = selectedRegion.executorOffices;
            // Якщо вибраний виконавець не входить в новий список - очистити
            if (!executors.any((e) => e.id == selectedExecutorId)) {
              selectedExecutorId = null;
            }
          } else {
            executors = [];
            selectedExecutorId = null;
          }

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
                    controller: addressController,
                    decoration: const InputDecoration(labelText: 'Адреса'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: decreeController,
                    decoration: const InputDecoration(labelText: 'Постанова'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: amountController,
                    decoration: const InputDecoration(labelText: 'Сума'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<int>(
                    decoration: const InputDecoration(labelText: 'Область'),
                    value: selectedRegionId,
                    items: [
                      const DropdownMenuItem<int>(
                        value: null,
                        child: Text('не вибрано'),
                      ),
                      ...regions.map(
                        (r) => DropdownMenuItem<int>(
                          value: r.id,
                          child: Text(r.name),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedRegionId = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<int>(
                    decoration: const InputDecoration(labelText: 'Виконавець'),
                    value: selectedExecutorId,
                    items: [
                      const DropdownMenuItem<int>(
                        value: null,
                        child: Text('не вибрано'),
                      ),
                      ...executors.map(
                        (e) => DropdownMenuItem<int>(
                          value: e.id,
                          child: Text(e.name),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedExecutorId = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  fullNameController.dispose();
                  decreeController.dispose();
                  amountController.dispose();
                  addressController.dispose();
                },
                child: const Text('Скасувати'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (fullNameController.text.trim().isEmpty) {
                    // Можна додати повідомлення про помилку
                    return;
                  }
                  final newDebtor = DebtorEntity(
                    id: 0,
                    fullName: fullNameController.text.trim(),
                    address: addressController.text.trim(),
                    decree: decreeController.text.trim(),
                    amount: amountController.text.trim(),
                    regionId: selectedRegionId,
                    executorId: selectedExecutorId,
                  );
                  context.read<DebtorCubit>().addDebtor(newDebtor);
                  Navigator.pop(dialogContext);
                  fullNameController.dispose();
                  decreeController.dispose();
                  amountController.dispose();
                },
                child: const Text('Додати'),
              ),
            ],
          );
        },
      );
    },
  );
}
