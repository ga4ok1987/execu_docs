import 'package:execu_docs/core/widgets/hover_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/executor_entity.dart';
import '../blocs/executor_office_cubit.dart';
import 'package:execu_docs/core/constants/index.dart';

import 'dialogs/edit_executor_dialog.dart';

class ExecutorTile extends StatelessWidget {
  final ExecutorEntity executor;

  const ExecutorTile({super.key, required this.executor});

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
          title: Text(executor.name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(executor.address),
              if (executor.isPrimary)
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
                    editExecutorDialog(
                        context, context.read<ExecutorCubit>(), executor),
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

  void _showContextMenu(BuildContext context,
      Offset position,
      ExecutorCubit cubit,) {
    final overlay = Overlay
        .of(context)
        .context
        .findRenderObject() as RenderBox;
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
          value: 'edit_${executor.id}',
          child: const Text(AppTexts.edit),
        ),
        PopupMenuItem<String>(
          value: 'delete_${executor.id}',
          child: const Text(AppTexts.delete),
        ),
      ],
    ).then((selected) {
      if (selected != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (selected.startsWith('edit')) {
            editExecutorDialog(context, cubit, executor);
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
      builder: (context) =>
          AlertDialog(
            backgroundColor: AppColors.primaryWhite,

            title: const Text(AppTexts.acceptDelete),
            content: Text(AppTexts.deleteExecutorConfirm(executor.name)),
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
                  cubit.removeOffice(executor);
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
}
