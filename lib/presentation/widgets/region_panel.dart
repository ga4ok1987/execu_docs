import 'package:execu_docs/presentation/widgets/region_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/region_entity.dart';
import '../blocs/region_cubit.dart';

class RegionPanel extends StatelessWidget {
  const RegionPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegionCubit, RegionState>(
      listenWhen: (prev, curr) => curr is RegionError,
      listener: (context, state) {
        if (state is RegionError) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Помилка'),
              content: Text(state.message),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      },
      child: Scaffold(
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
                return Padding(
                  padding: const EdgeInsets.only(right: 22.0),
                  child: IconButton(
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
            List<RegionEntity> regions = [];
            if (state is RegionLoaded) regions = state.regions;
            if (state is RegionError) regions = state.previousRegions;

            if (regions.isEmpty) {
              if (state is RegionLoading) return const Center(child: CircularProgressIndicator());
              return const Center(child: Text('Регіони не додані'));
            }

            return ListView.separated(
              itemCount: regions.length,
              itemBuilder: (context, index) => RegionTile(region: regions[index]),
              separatorBuilder: (_,__) => Divider(height:0, color: Colors.grey.shade300),
            );
          },
        ),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Новий регіон'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Назва регіону'),
            validator: (value) {
              final text = value?.trim() ?? '';
              if (text.isEmpty) return 'Введіть назву регіону';
              final st = context.read<RegionCubit>().state;
              final regions = st is RegionLoaded ? st.regions : (st is RegionError ? st.previousRegions : <RegionEntity>[]);
              if (regions.any((r) => r.name.toLowerCase() == text.toLowerCase())) {
                return 'Такий регіон вже існує';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Скасувати')),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                context.read<RegionCubit>().addRegion(RegionEntity(id: 0, name: controller.text.trim()));
                Navigator.pop(dialogContext);
              }
            },
            child: const Text('Додати'),
          ),
        ],
      ),
    );
  }
}
