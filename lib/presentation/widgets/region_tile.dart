import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/region_entity.dart';
import '../blocs/region_cubit.dart';
import '../blocs/region_selection_cubit.dart';

class RegionTile extends StatelessWidget {
  final RegionEntity region;
  final VoidCallback? onDoubleTap;

  const RegionTile({super.key, required this.region, this.onDoubleTap});

  @override
  Widget build(BuildContext context) {
    final selectionState = context.watch<RegionSelectionCubit>().state;
    final selectedRegion = selectionState.selectedRegion;

    final isSelected = selectedRegion?.id == region.id;
    return GestureDetector(
      onDoubleTap: () {
        context.read<RegionSelectionCubit>().selectRegion(region);
      },
      child: Listener(
        behavior: HitTestBehavior.deferToChild,
        onPointerDown: (event) {
          if (event.kind == PointerDeviceKind.mouse &&
              event.buttons == kSecondaryMouseButton) {
            final position = event.position;
            _showContextMenu(context, position);
          }
        },
        child: Container(
          color: isSelected ? Colors.grey.shade300 : Colors.white ,

          child: ListTile(
            title: Text(region.name),
            trailing: isSelected?SizedBox()
                : Row(
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
                  )

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
        content: Text('Ви дійсно хочете видалити регіон "${region.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Скасувати'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<RegionCubit>().removeRegion(region.id);
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

    // showMenu не використовує then чи async
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
          value: 'edit_${region.id}',
          child: const Text('Редагувати'),
        ),
        PopupMenuItem<String>(
          value: 'delete_${region.id}',
          child: const Text('Видалити'),
        ),
      ],
    ).then((selected) {
      // перенеси дії через SchedulerBinding, щоб уникнути context після async
      if (selected != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (selected.startsWith('edit')) {
            _showEditDialog(context);
          } else if (selected.startsWith('delete')) {
            context.read<RegionCubit>().removeRegion(region.id);
          }
        });
      }
    });
  }

  void _showEditDialog(BuildContext context) {
    final controller = TextEditingController(text: region.name);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Редагувати регіон'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Назва регіону'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Скасувати'),
          ),
          TextButton(
            onPressed: () {
              context.read<RegionCubit>().updateRegionName(
                region.id,
                controller.text,
              );
              Navigator.pop(context);
              controller.dispose();
            },
            child: const Text('Зберегти'),
          ),
        ],
      ),
    );
  }
}
