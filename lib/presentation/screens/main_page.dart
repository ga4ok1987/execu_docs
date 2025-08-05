import 'package:execu_docs/presentation/widgets/region_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';

import '../blocs/folder_cubit.dart';
import '../blocs/region_selection_cubit.dart';
import '../widgets/executors_offices_panel.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with TickerProviderStateMixin {
  late final AnimationController _regionPanelController;
  late final Animation<Offset> _regionPanelOffset;

  late final AnimationController _executorPanelController;
  late final Animation<Offset> _executorPanelOffset;

  bool _dataVisible = false;

  Future<void> _selectFolder(BuildContext context) async {
    final folderCubit = context.read<FolderCubit>(); // зберігаємо до await
    final result = await FilePicker.platform.getDirectoryPath();
    if (result != null) {
      folderCubit.setFolder(result);
    }
  }

  @override
  void initState() {
    super.initState();
    _regionPanelController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _regionPanelOffset = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: _regionPanelController, curve: Curves.easeInOut));

    _executorPanelController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _executorPanelOffset = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: _executorPanelController, curve: Curves.easeInOut));
  }

  void _toggleData() {
    if (_regionPanelController.isDismissed) {
      _regionPanelController.forward();
    } else {
      _regionPanelController.reverse();
    }
  }


  @override
  void dispose() {
    _regionPanelController.dispose();
    _executorPanelController.dispose();
    super.dispose();
  }


  double getDataWidth(BuildContext context) =>
      MediaQuery
          .of(context)
          .size
          .width * 1 / 4;

  @override
  Widget build(BuildContext context) {
    final folderPath = context
        .watch<FolderCubit>()
        .state;
    final dataWidth = getDataWidth(context);

    return BlocListener<RegionSelectionCubit, RegionSelectionState>(
        listener: (context, state) {
          if (state.isExecutorPanelOpen) {
            _executorPanelController.forward();
          } else {
            _executorPanelController.reverse();
          }
        },
        child: BlocBuilder<RegionSelectionCubit, RegionSelectionState>(
          builder: (context, state) {
            final isExecutorPanelOpen = state.isExecutorPanelOpen;
            final selectedRegion = state.selectedRegion;
            return Scaffold(
              appBar: AppBar(title: const Text('Перегляд документів')),
              body: Stack(
                children: [
                  Padding(
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
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
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
                            onPressed: () => _toggleData(),

                            child: const Text('Додати регіони'),
                          ),
                        ),

                        const SizedBox(height: 24),

                        /// 📄 Таблиця з рамкою
                        const Text(
                          'Документи',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),

                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: const _MockDocumentTable(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_regionPanelController.isCompleted ||
                      _regionPanelController.isAnimating)
                    GestureDetector(
                      onTap: _toggleData,
                      child: AnimatedOpacity(
                        opacity: _regionPanelController.value,
                        duration: const Duration(milliseconds: 300),
                        child: Container(
                          color: Colors.black,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                    ),

                  /// 🔳 Затемнення для ExecutorPanel
                  if (isExecutorPanelOpen)
                    GestureDetector(
                      onTap: () => context.read<RegionSelectionCubit>().clear(),
                      child: AnimatedOpacity(
                        opacity: 0.5,
                        duration: const Duration(milliseconds: 300),
                        child: Container(
                          color: Colors.black,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                    ),

                  /// 📦 Панель Регіонів, яка зсувається, якщо відкриті Виконавці
                  SlideTransition(
                    position: isExecutorPanelOpen
                        ? Tween<Offset>(
                      begin: Offset.zero,
                      end: const Offset(-0.4, 0),
                    ).animate(CurvedAnimation(parent: _executorPanelController,
                        curve: Curves.easeInOut))
                        : _regionPanelOffset,
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
                  ),

                  /// 📦 Панель Виконавців
                  SlideTransition(
                    position: _executorPanelOffset,
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
                              ? ExecutorOfficesPanel(regionId: selectedRegion.id)
                              : const SizedBox(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );

  }
}

/// 🔧 Мокові дані документів
class _MockDocumentTable extends StatelessWidget {
  const _MockDocumentTable();

  @override
  Widget build(BuildContext context) {
    final documents = [
      {
        'ПІБ': 'Іваненко І.І.',
        'Постанова': 'АА123456',
        'Сума': '340 грн',
        'Область': 'Тернопільська',
        'Виконавець': 'Тернопільське ВДВС',
      },
      {
        'ПІБ': 'Петренко П.П.',
        'Постанова': 'BB654321',
        'Сума': '510 грн',
        'Область': 'Львівська',
        'Виконавець': 'Львівське ВДВС',
      },
    ];

    return SingleChildScrollView(
      child: DataTable(
        columns: const [
          DataColumn(label: Text('ПІБ')),
          DataColumn(label: Text('Постанова')),
          DataColumn(label: Text('Сума')),
          DataColumn(label: Text('Область')),
          DataColumn(label: Text('Виконавець')),
        ],
        rows: documents.map((doc) {
          return DataRow(
            cells: [
              DataCell(Text(doc['ПІБ']!)),
              DataCell(Text(doc['Постанова']!)),
              DataCell(Text(doc['Сума']!)),
              DataCell(Text(doc['Область']!)),
              DataCell(Text(doc['Виконавець']!)),
            ],
          );
        }).toList(),
      ),
    );
  }
}
