import 'package:execu_docs/presentation/widgets/region_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/region_entity.dart';
import '../blocs/region_cubit.dart';

class RegionPanel extends StatelessWidget {
  const RegionPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Регіони'),
        backgroundColor: Colors.white,
        actions: [
          BlocBuilder<RegionCubit, RegionState>(
            builder: (context, state) {
              if (state is RegionLoading) {
                return const Padding(
                  padding: EdgeInsets.only(right: 22.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              // Ігноруємо інші стани — дозволяємо додавати регіон, якщо є завантаження чи помилка
              return Padding(
                padding: const EdgeInsets.only(right: 22.0),
                child: IconButton(
                  style: IconButton.styleFrom(backgroundColor: Colors.redAccent),
                  highlightColor: Colors.blueAccent,
                  hoverColor: Colors.amber,
                  onPressed: () => _showAddDialog(context),
                  icon: const Icon(Icons.add),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<RegionCubit, RegionState>(
        builder: (context, state) {
          if (state is RegionLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is RegionError) {
            return Center(child: Text('Помилка: ${state.message}'));
          }
          if (state is RegionLoaded) {
            final regions = state.regions;
            if (regions.isEmpty) {
              return const Center(child: Text('Регіони не додані'));
            }
            return ListView.separated(
              itemCount: regions.length,
              itemBuilder: (context, index) {
                return RegionTile(region: regions[index]);
              },
              separatorBuilder: (_, __) =>
                  Divider(height: 0, color: Colors.grey.shade500),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Новий регіон'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Назва регіону'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.dispose();
              Navigator.pop(dialogContext);
            },
            child: const Text('Скасувати'),
          ),
          TextButton(
            onPressed: () {
              final text = controller.text.trim();
              if (text.isEmpty) return;

              // ІД = 0, бо має генеруватися на бекенді/в БД
              context.read<RegionCubit>().addRegion(
                RegionEntity(id: 0, name: text),
              );
              controller.dispose();
              Navigator.pop(dialogContext);
            },
            child: const Text('Додати'),
          ),
        ],
      ),
    );
  }
}
