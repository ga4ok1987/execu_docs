import 'package:flutter/material.dart';

import '../../../domain/entities/executor_entity.dart';
import '../../../presentation/blocs/executor_office_cubit.dart';

void addExecutorDialog(BuildContext context, ExecutorCubit cubit) {
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  bool isPrimary = false;

  showDialog(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Додати виконавчу службу'),
            content: SizedBox(
              width: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Назва служби',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: addressController,
                    decoration: const InputDecoration(
                      labelText: 'Адреса',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Checkbox(
                        value: isPrimary,
                        onChanged: (value) =>
                            setState(() => isPrimary = value ?? false),
                      ),
                      const Text('Основна служба'),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Скасувати'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty &&
                      addressController.text.isNotEmpty) {
                    final newOffice = ExecutorEntity(
                      id: 0,
                      name: nameController.text.trim(),
                      address: addressController.text.trim(),
                      isPrimary: isPrimary,
                      regionId: cubit.regionId,
                    );
                    cubit.addOffice(
                      newOffice,
                    ); // <-- використовуємо переданий кубіт
                    Navigator.pop(dialogContext);
                  }
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