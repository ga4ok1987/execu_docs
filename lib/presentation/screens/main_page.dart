import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';

import '../blocs/folder_cubit.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  Future<void> _selectFolder(BuildContext context) async {
    final result = await FilePicker.platform.getDirectoryPath();
    if (result != null) {
      context.read<FolderCubit>().setFolder(result);
    }
  }

  @override@override
  Widget build(BuildContext context) {
    final folderPath = context.watch<FolderCubit>().state;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Перегляд документів'),
      ),
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
                onPressed: () => context.go('/data'),
                child: const Text('Додати регіони'),
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
                child: const _MockDocumentTable(),
              ),
            ),
          ],
        ),
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
          return DataRow(cells: [
            DataCell(Text(doc['ПІБ']!)),
            DataCell(Text(doc['Постанова']!)),
            DataCell(Text(doc['Сума']!)),
            DataCell(Text(doc['Область']!)),
            DataCell(Text(doc['Виконавець']!)),
          ]);
        }).toList(),
      ),
    );
  }
}