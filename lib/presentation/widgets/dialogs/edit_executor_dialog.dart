import 'package:flutter/material.dart';
import '../../../core/constants/index.dart';
import '../../../core/widgets/hover_button.dart';
import '../../../domain/entities/executor_entity.dart';
import '../../blocs/executor_office_cubit.dart';

void editExecutorDialog(
  BuildContext context,
  ExecutorCubit cubit,
  ExecutorEntity executor,
) {
  final nameController = TextEditingController(text: executor.name);
  final addressController = TextEditingController(text: executor.address);
  final formKey = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();

  bool isPrimary = executor.isPrimary;

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

                    activeColor: AppColors.primaryMainBlue,
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
              final isAddressValid = formKey2.currentState?.validate() ?? false;

              if (isNameValid && isAddressValid) {
                final updatedOffice = ExecutorEntity(
                  id: executor.id,
                  name: nameController.text,
                  address: addressController.text,
                  isPrimary: isPrimary,
                  regionId: executor.regionId,
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
