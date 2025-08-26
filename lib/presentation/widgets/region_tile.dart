import 'package:execu_docs/core/constants/index.dart';
import 'package:execu_docs/core/widgets/hover_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../domain/entities/region_entity.dart';
import '../blocs/region_cubit.dart';
import '../blocs/region_selection_cubit.dart';

class RegionTile extends StatelessWidget {
  final RegionEntity region;

  const RegionTile({super.key, required this.region});

  @override
  Widget build(BuildContext context) {
    final selectionState = context.watch<RegionSelectionCubit>().state;
    final selectedRegion = selectionState.selectedRegion;

    final isSelected = selectedRegion?.id == region.id;
    return GestureDetector(
      onTap: () {
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
          color: selectedRegion == null
              ? Colors.white
              : isSelected
              ? Colors.white
              : Colors.grey.shade500,

          child: Slidable(
            enabled: selectedRegion != null ? false : true,
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              extentRatio: 0.5,

              children: [
                SlidableAction(
                  onPressed: (context) => _confirmDeletion(context),
                  backgroundColor: Color(0xFFFE4A49),
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                ),
                SlidableAction(
                  onPressed: (context) => _showEditDialog(context),
                  backgroundColor: Color(0xFF21B7CA),
                  foregroundColor: Colors.white,
                  icon: Icons.edit,
                ),
              ],
            ),

            child: Container(
              color: selectedRegion == null
                  ? Colors.white
                  : isSelected
                  ? Colors.white
                  : Colors.grey.shade500,
              width: double.infinity,
              child: ListTile(
                title: Text(region.name),

                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
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
      color: AppColors.primaryWhite,
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
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400, maxHeight: 300),
          child: Container(
            padding: AppPadding.all16,
            decoration: BoxDecoration(
              color: AppColors.primaryWhite,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Form(
              key: formKey, // додали ключ форми
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Редагувати регіон',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  AppGaps.w16,

                  TextFormField(
                    controller: controller,
                    decoration: const InputDecoration(
                      labelText: 'Назва регіону',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Назва регіону не може бути порожньою';
                      }
                      return null;
                    },
                  ),
                  AppGaps.w16,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      HoverButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Скасувати',
                          style: TextStyle(color: AppColors.textButtonWhite),
                        ),
                      ),
                      AppGaps.w12,

                      HoverButton(
                        onPressed: () {
                          if (formKey.currentState?.validate() ?? false) {
                            context.read<RegionCubit>().updateRegionName(
                              region.id,
                              controller.text.trim(),
                            );
                            Navigator.pop(context);
                          }
                        },
                        child: const Text(
                          'Зберегти',
                          style: TextStyle(color: AppColors.textButtonWhite),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
