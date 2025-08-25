import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/region_entity.dart';
import '../../../presentation/blocs/region_cubit.dart';

void addRegionDialog(BuildContext context) {
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
