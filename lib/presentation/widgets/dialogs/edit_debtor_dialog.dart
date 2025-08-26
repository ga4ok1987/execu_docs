import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/debtor_entity.dart';
import '../../../domain/entities/executor_entity.dart';
import '../../../domain/entities/region_entity.dart';
import '../../../presentation/blocs/debtor_cubit.dart';
import '../../../presentation/blocs/region_cubit.dart';

void editDebtorDialog(BuildContext context, DebtorEntity debtor) {
  final fullNameController = TextEditingController(text: debtor.fullName);
  final decreeController = TextEditingController(text: debtor.decree);
  final amountController = TextEditingController(text: debtor.amount);
  final addressController = TextEditingController(text: debtor.address);

  final regions = context.read<RegionCubit>().state is RegionLoaded
      ? (context.read<RegionCubit>().state as RegionLoaded).regions
      : <RegionEntity>[];

  int? selectedRegionId = debtor.regionId;
  int? selectedExecutorId = debtor.executorId;
  List<ExecutorEntity> executors = [];

  final formKey = GlobalKey<FormState>();

  showDialog(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          /// Оновлення виконавців при виборі регіону
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
            backgroundColor: Colors.white,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 600,
                maxHeight: 600,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Редагувати боржника',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      /// Поля вводу
                      TextFormField(
                        controller: fullNameController,
                        decoration: const InputDecoration(labelText: 'ПІБ'),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Поле ПІБ є обов’язковим';
                          }
                          return null;
                        },
                      ),
                      TextField(
                        controller: addressController,
                        decoration: const InputDecoration(labelText: 'Адреса'),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: decreeController,
                        decoration: const InputDecoration(labelText: 'Постанова'),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: amountController,
                        decoration: const InputDecoration(labelText: 'Сума'),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),

                      /// Dropdown область
                      DropdownButtonFormField<int>(
                        decoration: const InputDecoration(labelText: 'Область'),
                        value: selectedRegionId,
                        items: [
                          const DropdownMenuItem<int>(
                            value: null,
                            child: Text('не вибрано'),
                          ),
                          ...regions.map(
                                (r) => DropdownMenuItem<int>(
                              value: r.id,
                              child: Text(r.name),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedRegionId = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      /// Dropdown виконавець
                      DropdownButtonFormField<int>(
                        decoration:
                        const InputDecoration(labelText: 'Виконавець'),
                        value: selectedExecutorId,
                        items: [
                          const DropdownMenuItem<int>(
                            value: null,
                            child: Text('не вибрано'),
                          ),
                          ...executors.map(
                                (e) => DropdownMenuItem<int>(
                              value: e.id,
                              child: Text(e.name),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedExecutorId = value;
                          });
                        },
                      ),

                      const SizedBox(height: 24),

                      /// Кнопки
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(dialogContext);
                            },
                            child: const Text('Скасувати'),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: () {
                              if (!formKey.currentState!.validate()) {
                                return;
                              }
                              final updatedDebtor = debtor.copyWith(
                                fullName: fullNameController.text.trim(),
                                address: addressController.text.trim(),
                                decree: decreeController.text.trim(),
                                amount: amountController.text.trim(),
                                regionId: selectedRegionId,
                                executorId: selectedExecutorId,
                              );
                              context.read<DebtorCubit>().updateDebtor(updatedDebtor);
                              Navigator.pop(dialogContext);
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
        },
      );
    },
  );
}
