import 'package:execu_docs/core/widgets/hover_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/executor_entity.dart';
import '../blocs/executor_office_cubit.dart';
import 'package:execu_docs/core/constants/index.dart';

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
        color: AppColors.primaryWhite,
        child: ListTile(
          title: Text(office.name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(office.address),
              if (office.isPrimary)
                const Text(
                  AppTexts.selectedExecutor,
                  style: TextStyle(
                    color: AppColors.texBlue,
                    fontSize: AppTextSizes.large,
                    fontWeight: FontWeight.bold,
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

  void _showContextMenu(
    BuildContext context,
    Offset position,
    ExecutorCubit cubit,
  ) {
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final offset = overlay.localToGlobal(Offset.zero);

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
          value: 'edit_${office.id}',
          child: const Text(AppTexts.edit),
        ),
        PopupMenuItem<String>(
          value: 'delete_${office.id}',
          child: const Text(AppTexts.delete),
        ),
      ],
    ).then((selected) {
      if (selected != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (selected.startsWith('edit')) {
            _showEditDialog(context, cubit);
          } else if (selected.startsWith('delete')) {
            _confirmDeletion(context, cubit);
          }
        });
      }
    });
  }

  void _confirmDeletion(BuildContext context, ExecutorCubit cubit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.primaryWhite,

        title: const Text(AppTexts.acceptDelete),
        content: Text(AppTexts.deleteExecutorConfirm(office.name)),
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
              cubit.removeOffice(office);
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

  void _showEditDialog(BuildContext context, ExecutorCubit cubit) {
    final nameController = TextEditingController(text: office.name);
    final addressController = TextEditingController(text: office.address);
    final formKey = GlobalKey<FormState>();
    final formKey2 = GlobalKey<FormState>();

    bool isPrimary = office.isPrimary;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (statefulContext, setState) => AlertDialog(
          backgroundColor: AppColors.primaryWhite,
          title: const Text(AppTexts.editExecutor),
          content: SizedBox(
            width: AppSizes.alertDialogHeight300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: formKey,
                  child: TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: AppTexts.nameExecutor,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return AppTexts.nameExecutorEmpty;
                      }
                      return null;
                    },
                  ),
                ),
                AppGaps.h16,
                Form(
                  key: formKey2,
                  child: TextFormField(
                    controller: addressController,
                    decoration: const InputDecoration(
                      labelText: AppTexts.address,
                    ),
                    maxLines: 2,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return AppTexts.addressExecutorEmpty;
                      }
                      return null;
                    },
                  ),
                ),
                AppGaps.h16,
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
                    const Text(AppTexts.mainExecutor),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            HoverButton(
              color: AppColors.backgroundButtonRed,

              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                AppTexts.cancel,
                style: TextStyle(color: AppColors.textButtonWhite),
              ),
            ),
            AppGaps.w12,

            HoverButton(
              onPressed: () {
                final isNameValid = formKey.currentState?.validate() ?? false;
                final isAddressValid =
                    formKey2.currentState?.validate() ?? false;

                if (isNameValid && isAddressValid) {
                  final updatedOffice = ExecutorEntity(
                    id: office.id,
                    name: nameController.text,
                    address: addressController.text,
                    isPrimary: isPrimary,
                    regionId: office.regionId,
                  );

                  cubit.editOffice(updatedOffice);
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text(
                AppTexts.save,
                style: TextStyle(color: AppColors.textButtonWhite),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
