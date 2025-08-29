import 'package:execu_docs/core/constants/index.dart';
import 'package:execu_docs/core/widgets/hover_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/debtor_entity.dart';
import '../../../domain/entities/executor_entity.dart';
import '../../../domain/entities/region_entity.dart';
import '../../../presentation/blocs/debtor_cubit.dart';
import '../../../presentation/blocs/region_cubit.dart';

void addDebtorDialog(BuildContext context) {
  final fullNameController = TextEditingController();
  final decreeController = TextEditingController();
  final amountController = TextEditingController();
  final addressController = TextEditingController();

  final regions = context.read<RegionCubit>().state is RegionLoaded
      ? (context.read<RegionCubit>().state as RegionLoaded).regions
      : <RegionEntity>[];

  int? selectedRegionId;
  int? selectedExecutorId;
  List<ExecutorEntity> executors = [];

  final formKey = GlobalKey<FormState>();

  showDialog(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          // Оновлення виконавців при виборі регіону
          if (selectedRegionId != null) {
            final selectedRegion = regions.firstWhere(
              (r) => r.id == selectedRegionId,
              orElse: () => RegionEntity(id: 0, name: '', executorOffices: []),
            );
            executors = selectedRegion.executorOffices;
            if (!executors.any((e) => e.id == selectedExecutorId)) {
              selectedExecutorId = null;
            }
          } else {
            executors = [];
            selectedExecutorId = null;
          }

          return Dialog(
            backgroundColor: AppColors.primaryWhite,
            child: ConstrainedBox(
              constraints: AppConstraints.box500x500,
              child: Padding(
                padding: AppPadding.all16,
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        AppTexts.addDebtor,
                        style: TextStyle(
                          fontSize: AppTextSizes.big,
                          fontWeight: FontWeight.bold,
                          color: AppColors.texBlack,
                        ),
                      ),
                      AppGaps.h16,

                      /// Поля вводу
                      TextFormField(
                        controller: fullNameController,
                        decoration: const InputDecoration(
                          labelText: AppTexts.fullName,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return AppTexts.fullNameIsRequired;
                          }
                          return null;
                        },
                      ),
                      AppGaps.h16,
                      TextField(
                        controller: addressController,
                        decoration: const InputDecoration(
                          labelText: AppTexts.address,
                        ),
                      ),
                      AppGaps.h8,
                      TextField(
                        controller: decreeController,
                        decoration: const InputDecoration(
                          labelText: AppTexts.decree,
                        ),
                      ),
                      AppGaps.h8,
                      TextField(
                        controller: amountController,
                        decoration: const InputDecoration(
                          labelText: AppTexts.amount,
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      AppGaps.h16,

                      /// Dropdown області
                      DropdownButtonFormField<int>(
                        decoration: const InputDecoration(
                          labelText: AppTexts.region,
                        ),
                        dropdownColor: AppColors.dropdownColorWhite,
                        value: selectedRegionId,
                        items: [
                          const DropdownMenuItem<int>(
                            value: null,
                            child: Text(
                              AppTexts.dropdownNotSelected,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          ...regions.map(
                            (r) => DropdownMenuItem<int>(
                              value: r.id,
                              child: Text(
                                r.name,
                                overflow: TextOverflow.ellipsis,
                                // обрізає довгий текст
                                maxLines: 1, // тільки 1 рядок
                              ),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedRegionId = value;
                          });
                        },
                      ),
                      AppGaps.h16,

                      /// Dropdown виконавця
                      DropdownButtonFormField<int>(
                        decoration: const InputDecoration(
                          labelText: AppTexts.executor,
                        ),
                        dropdownColor: AppColors.dropdownColorWhite,
                        // фон списку
                        value: selectedExecutorId,
                        isExpanded: true,
                        items: [
                          const DropdownMenuItem<int>(
                            value: null,
                            child: Text(
                              AppTexts.dropdownNotSelected,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                          ...executors.map(
                            (e) => DropdownMenuItem<int>(
                              value: e.id,
                              child: SizedBox(
                                child: Text(
                                  e.name,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                ),
                              ),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedExecutorId = value;
                          });
                        },
                      ),

                      AppGaps.h16,

                      /// Кнопки
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          HoverButton(
                            color: AppColors.backgroundButtonRed,
                            onPressed: () {
                              Navigator.pop(dialogContext);
                            },
                            child: const Text(
                              AppTexts.cancel,
                              style: TextStyle(
                                color: AppColors.textButtonWhite,
                              ),
                            ),
                          ),
                          AppGaps.w12,

                          HoverButton(
                            onPressed: () {
                              if (!formKey.currentState!.validate()) {
                                return;
                              }
                              final newDebtor = DebtorEntity(
                                id: 0,
                                fullName: fullNameController.text.trim(),
                                address: addressController.text.trim(),
                                decree: decreeController.text.trim(),
                                amount: amountController.text.trim(),
                                regionId: selectedRegionId,
                                executorId: selectedExecutorId,
                              );
                              context.read<DebtorCubit>().addDebtor(newDebtor);
                              Navigator.pop(dialogContext);
                            },
                            child: const Text(
                              AppTexts.add,
                              style: TextStyle(
                                color: AppColors.textButtonWhite,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
