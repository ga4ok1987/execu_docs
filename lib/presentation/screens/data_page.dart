import 'package:execu_docs/presentation/widgets/data_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/region_entity.dart';
import '../blocs/region_cubit.dart';


class DataPage extends StatelessWidget {
  const DataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Регіони')),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<RegionCubit, List<RegionEntity>>(
              builder: (context, regions) {
                return ListView.separated(
                  itemCount: regions.length,
                  itemBuilder: (context, index) {
                    return DataTile(region: regions[index]);
                  },
                  separatorBuilder: (_, __) => const Divider(height: 0),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: () => _showAddDialog(context),
              icon: const Icon(Icons.add),
              label: const Text('Додати регіон'),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Новий регіон'),
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
              context.read<RegionCubit>().addRegion(RegionEntity(id: 1, name: controller.text));
              Navigator.pop(context);
            },
            child: const Text('Додати'),
          ),
        ],
      ),
    );
  }
}