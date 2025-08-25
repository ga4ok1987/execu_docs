import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/executor_entity.dart';
import '../blocs/executor_office_cubit.dart';

class ExecutorTile extends StatelessWidget {
  final ExecutorEntity office;

  const ExecutorTile({super.key, required this.office});

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.deferToChild,
      onPointerDown: (event) {
        if (event.kind == PointerDeviceKind.mouse &&
            event.buttons == kSecondaryMouseButton) {
          final position = event.position;
          _showContextMenu(context, position, context.read<ExecutorCubit>());
        }
      },
      child: Container(
        color: Colors.white,
        child: ListTile(
          title: Text(office.name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(office.address),
              if (office.isPrimary)
                Container(
                  color: Colors.white,
                  child: const Text(
                    'Основна',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () =>
                    _showEditDialog(context, context.read<ExecutorCubit>()),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () =>
                    _confirmDeletion(context, context.read<ExecutorCubit>()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDeletion(BuildContext context, ExecutorCubit cubit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Підтвердити видалення'),
        content: Text('Ви дійсно хочете видалити службу "${office.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Скасувати'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              cubit.removeOffice(office);
            },
            child: const Text('Видалити'),
          ),
        ],
      ),
    );
  }

  void _showContextMenu(
    BuildContext context,
    Offset position,
    ExecutorCubit cubit,
  ) {
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final offset = overlay.localToGlobal(Offset.zero);

    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        offset.dx + overlay.size.width - position.dx,
        offset.dy + overlay.size.height - position.dy,
      ),
      items: [
        PopupMenuItem<String>(
          value: 'edit_${office.id}',
          child: const Text('Редагувати'),
        ),
        PopupMenuItem<String>(
          value: 'delete_${office.id}',
          child: const Text('Видалити'),
        ),
      ],
    ).then((selected) {
      if (selected != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (selected.startsWith('edit')) {
            _showEditDialog(context, cubit);
          } else if (selected.startsWith('delete')) {
            cubit.removeOffice(office);
          }
        });
      }
    });
  }

  void _showEditDialog(BuildContext context, ExecutorCubit cubit) {
    final nameController = TextEditingController(text: office.name);
    final addressController = TextEditingController(text: office.address);
    bool isPrimary = office.isPrimary;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (statefulContext, setState) => AlertDialog(
          title: const Text('Редагувати службу'),
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
                      onChanged: (value) {
                        setState(() {
                          isPrimary = value ?? false;
                        });
                      },
                    ),
                    const Text('Основна служба'),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                nameController.dispose();
                addressController.dispose();
                Navigator.pop(dialogContext);
              },
              child: const Text('Скасувати'),
            ),
            ElevatedButton(
              onPressed: () {
                final updatedOffice = ExecutorEntity(
                  id: office.id,
                  name: nameController.text,
                  address: addressController.text,
                  isPrimary: isPrimary,
                  regionId: office.regionId,
                );

                cubit.editOffice(updatedOffice);
                Navigator.pop(dialogContext);
              },
              child: const Text('Зберегти'),
            ),
          ],
        ),
      ),
    );
  }
}
