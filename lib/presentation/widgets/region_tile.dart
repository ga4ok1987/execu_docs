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
              ? AppColors.primaryWhite
              : isSelected
              ? AppColors.primaryWhite
              : AppColors.regionsShadow,

          child: Slidable(
            enabled: selectedRegion != null ? false : true,
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              extentRatio: 0.5,

              children: [
                SlidableAction(
                  onPressed: (context) => _confirmDeletion(context),
                  backgroundColor: AppColors.backgroundButtonRed,
                  foregroundColor: AppColors.primaryWhite,
                  icon: Icons.delete,
                ),
                SlidableAction(
                  onPressed: (context) => _showEditDialog(context),
                  backgroundColor: AppColors.backgroundButtonBlue,
                  foregroundColor: AppColors.primaryWhite,
                  icon: Icons.edit,
                ),
              ],
            ),

            child: Container(
              color: selectedRegion == null
                  ? AppColors.primaryWhite
                  : isSelected
                  ? AppColors.primaryWhite
                  : AppColors.regionsShadow,
              width: double.infinity,
              child: ListTile(
                title: Text(region.name),
                contentPadding: AppPadding.horizontal16,
              ),
            ),
          ),
        ),
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

          child: const Text(AppTexts.edit),
        ),
        PopupMenuItem<String>(
          value: 'delete_${region.id}',
          child: const Text(AppTexts.delete),
        ),
      ],
    ).then((selected) {
      // перенеси дії через SchedulerBinding, щоб уникнути context після async
      if (selected != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (selected.startsWith('edit')) {
            _showEditDialog(context);
          } else if (selected.startsWith('delete')) {
            _confirmDeletion(context);
          }
        });
      }
    });
  }

  void _confirmDeletion(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.primaryWhite,

        title: const Text(AppTexts.acceptDelete),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppTexts.alertDelete),
            Text(AppTexts.deleteRegionConfirm(region.name)),
          ],
        ),
        actions: [
          HoverButton(
            onPressed: () => Navigator.pop(context),
            color: AppColors.backgroundButtonRed,
            child: const Text(
              AppTexts.cancel,
              style: TextStyle(color: AppColors.textButtonWhite),
            ),
          ),
          HoverButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<RegionCubit>().removeRegion(region.id);
            },
            child: const Text(
              AppTexts.delete,
              style: TextStyle(color: AppColors.textButtonWhite),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    final controller = TextEditingController(text: region.name);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.primaryWhite,
        title: Text(AppTexts.editRegion),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: AppTexts.nameRegion,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return AppTexts.nameRegionEmpty;
              }
              return null;
            },
          ),
        ),
        actions: [
          HoverButton(
            onPressed: () => Navigator.pop(context),
            color: AppColors.backgroundButtonRed,
            child: const Text(
              AppTexts.cancel,
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
              AppTexts.save,
              style: TextStyle(color: AppColors.textButtonWhite),
            ),
          ),
        ],
      ),
    );
  }
}
