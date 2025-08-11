import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/di/di.dart';
import '../../domain/entities/executor_office_entity.dart';
import '../../domain/entities/region_entity.dart';
import '../../domain/usecases/get_region_by_id_usecase.dart';
import '../../domain/usecases/update_region_usecase.dart';
import '../blocs/executor_office_cubit.dart';
import '../blocs/region_selection_cubit.dart';
import 'executor_office_tile.dart';

class ExecutorOfficesPanel extends StatelessWidget {
  final RegionEntity region;

  const ExecutorOfficesPanel({super.key, required this.region});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ExecutorOfficeCubit(
        regionId: region.id,
        getRegionById: getIt<GetRegionByIdUseCase>(),
        updateRegion: getIt<UpdateRegionUseCase>(),
      )..loadOffices(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Виконавчі служби регіону ${region.name}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          actions: [
            BlocBuilder<ExecutorOfficeCubit, ExecutorOfficeState>(
              builder: (context, state) {
                return IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _showAddDialog(context),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => context.read<RegionSelectionCubit>().clear(),
            ),
          ],
        ),
        body: BlocBuilder<ExecutorOfficeCubit, ExecutorOfficeState>(
          builder: (context, state) {
            if (state is ExecutorOfficeLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ExecutorOfficeError) {
              return Center(child: Text('Помилка: ${state.message}'));
            } else if (state is ExecutorOfficeLoaded) {
              if (state.offices.isEmpty) {
                return const Center(child: Text('Виконавчих служб ще не додано'));
              }
              return ListView.separated(
                itemCount: state.offices.length,
                itemBuilder: (context, index) {
                  return ExecutorTile(office: state.offices[index]);
                },
                separatorBuilder: (_, __) => const Divider(height: 0),
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final nameController = TextEditingController();
    final addressController = TextEditingController();
    bool isPrimary = false;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Додати виконавчу службу'),
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
                    Navigator.pop(dialogContext);
                    nameController.dispose();
                    addressController.dispose();
                  },
                  child: const Text('Скасувати'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty &&
                        addressController.text.isNotEmpty) {
                      final newOffice = ExecutorOfficeEntity(
                        id: 0,
                        name: nameController.text.trim(),
                        address: addressController.text.trim(),
                        isPrimary: isPrimary,
                        regionId: region.id,
                      );
                      context.read<ExecutorOfficeCubit>().addOffice(newOffice);
                      Navigator.pop(dialogContext);
                      nameController.dispose();
                      addressController.dispose();
                    }
                  },
                  child: const Text('Додати'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
