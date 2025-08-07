import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/executor_office_entity.dart';


class ExecutorTile extends StatelessWidget {
  final ExecutorOfficeEntity office;

  const ExecutorTile({super.key, required this.office,});

  @override
  Widget build(BuildContext context) {

    return Listener(
      behavior: HitTestBehavior.deferToChild,
      onPointerDown: (event) {
        if (event.kind == PointerDeviceKind.mouse &&
            event.buttons == kSecondaryMouseButton) {
          final position = event.position;
          _showContextMenu(context, position);
        }
      },
      child: Container(
        color: Colors.white
            ,
        child: ListTile(
          title: Text(office.name),
          subtitle: Text(office.address),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _showEditDialog(context),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _confirmDeletion(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDeletion(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Підтвердити видалення'),
        content: Text('Ви дійсно хочете видалити офіс "${office.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Скасувати'),
          ),
          TextButton(
            onPressed: () {

            },
            child: const Text('Видалити'),
          ),
        ],
      ),
    );
  }

  void _showContextMenu(BuildContext context, Offset position) {
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
            _showEditDialog(context);
          } else if (selected.startsWith('delete')) {
            context.read<ExecutorCubit>().removeExecutor(office.id);
          }
        });
      }
    });
  }

  void _showEditDialog(BuildContext context) {
    final nameController = TextEditingController(text: office.name);
    final addressController = TextEditingController(text: office.address);

    showDialog(
      context: context,
      builder: (context) => Align(
        alignment: Alignment.centerRight,
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 300,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).dialogBackgroundColor,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Редагувати офіс', style: TextStyle(fontSize: 18)),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Назва офісу'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(labelText: 'Адреса'),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Скасувати'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ExecutorCubit>().updateExecutor(
                          office.copyWith(
                            name: nameController.text,
                            address: addressController.text,
                          ),
                        );
                        Navigator.pop(context);
                        nameController.dispose();
                        addressController.dispose();
                      },
                      child: const Text('Зберегти'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
