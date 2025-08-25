import 'package:execu_docs/core/widgets/confirm_dialog.dart';
import 'package:execu_docs/core/widgets/hover_button.dart';
import 'package:execu_docs/presentation/widgets/custom_expansion_tile.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/widgets/highlight_container.dart';
import '../blocs/debtor_cubit.dart';
import '../blocs/folder_cubit.dart';
import '../blocs/panels_cubit.dart';
import 'debtors_table.dart';
import 'dialogs/add_debtor_dialog.dart';

class MainPanel extends StatelessWidget {
  const MainPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedRowNotifier = ValueNotifier<List<int>?>(null);

    final folderPath = context.watch<FolderCubit>().state;

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,

            children: [
              SizedBox(
                height: 80,
                width: 953,
                child: HighlightContainer(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Підготовка документів для подання до виконавчих органів',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      HoverButton(
                        onPressed: () =>
                            context.read<PanelsCubit>().toggleRegionPanel(),
                        child: Text(
                          'Виконавці',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 66,
                    width: 1000 / 2.1,
                    child: HighlightContainer(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          HoverButton(
                            child: Text(
                              'Завантажити файли',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              if (folderPath.path1 != null) {
                                context.read<DebtorCubit>().importFromDocx(
                                  folderPath.path1!,
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Спочатку виберіть папку'),
                                  ),
                                );
                              }
                            },
                          ),

                          HoverButton(
                            child: Text(
                              'Створити супровідні',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {

                              context.read<DebtorCubit>().exportDebtors(folderPath.path2!);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 1000 / 2.1,

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
                                        (folderPath.path1 ??
                                            'Папку не вибрано'),
                                        maxLines: 1,
                                        style: const TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 20),

                                  HoverButton(
                                    onPressed: () => _selectFolder(context, 1),
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
                                    (folderPath.path2 ?? 'Папку не вибрано'),
                                    maxLines: 1,
                                    style: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(width: 20),
                              HoverButton(
                                onPressed: () => _selectFolder(context, 2),
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
                ],
              ),

              SizedBox(
                width: 450,
                child: HighlightContainer(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: HoverButton(
                          onPressed: () => addDebtorDialog(context),
                          isCircle: true,
                          child: Icon(Icons.add, color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: HoverButton(
                          isCircle: true,
                          child: Icon(Icons.edit, color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: HoverButton(
                          onPressed: () async {
                            final selectedId = selectedRowNotifier.value;
                            if (selectedId != null) {
                              await context.read<DebtorCubit>().deleteDebtor(
                                selectedId[0],
                              );
                              selectedRowNotifier.value = null;
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Спочатку виберіть боржника'),
                                ),
                              );
                            }
                          },
                          isCircle: true,
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: HoverButton(
                          onPressed: () => confirmDialog(context: context, title: 'title', message: 'message', onConfirm: () => context.read<DebtorCubit>().clearDebtors()),
                          child: Text(
                            'Очистити все',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: HighlightContainer(
                  child: DebtorsTable(
                    selectedRowNotifier: selectedRowNotifier,
                    rowCount: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



Future<void> _selectFolder(BuildContext context, int index) async {
  final folderCubit = context.read<FolderCubit>();
  final result = await FilePicker.platform.getDirectoryPath();
  if (result != null) {
    if (index == 1) {
      folderCubit.setFolder1(result);
    } else if (index == 2) {
      folderCubit.setFolder2(result);
    }
  }
}

