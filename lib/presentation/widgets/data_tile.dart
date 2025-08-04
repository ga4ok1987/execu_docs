import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/region_entity.dart';
import '../blocs/region_cubit.dart';

class DataTile extends StatelessWidget {
  final RegionEntity region;

  const DataTile({super.key, required this.region});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(region.name),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showEditDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => context.read<RegionCubit>().removeRegion(region.id),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    final controller = TextEditingController(text: region.name);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Редагувати регіон'),
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
              // context.read<RegionCubit>().upDateRegion(
              //   region.copyWith(name: controller.text),
              // );
              // Navigator.pop(context);
            },
            child: const Text('Зберегти'),
          ),
        ],
      ),
    );
  }
}