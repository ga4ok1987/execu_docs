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
      appBar: AppBar(title: const Text('Регіони'),
        backgroundColor: Colors.white,
        actions: [
        BlocBuilder<RegionCubit, List<RegionEntity>>(
          builder: (context, state) {
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
        )
      ],),
      body: BlocBuilder<RegionCubit, List<RegionEntity>>(
        builder: (context, regions) {
          return ListView.separated(
            itemCount: regions.length,
            itemBuilder: (context, index) {
              return RegionTile(region: regions[index]);
            },
            separatorBuilder: (_, __) =>
                Divider(height: 0, color: Colors.grey.shade500,),
          );
        },
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) =>
          AlertDialog(
            title: const Text('Новий регіон'),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(labelText: 'Назва регіону'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Скасувати'),
              ),
              TextButton(
                onPressed: () {
                  // ВАЖЛИВО: використовуй context, де є BlocProvider — тобто з _першого_ контексту
                  context.read<RegionCubit>().addRegion(
                    RegionEntity(id: 1, name: controller.text),
                  );
                  Navigator.pop(dialogContext);
                  controller.dispose();
                },
                child: const Text('Додати'),
              ),
            ],
          ),
    );
  }
}