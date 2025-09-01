import 'package:execu_docs/core/widgets/hover_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:execu_docs/core/constants/index.dart';
import '../../../domain/entities/region_entity.dart';
import '../../../presentation/blocs/region_cubit.dart';

void addRegionDialog(BuildContext context) {
  final controller = TextEditingController();
  final formKey = GlobalKey<FormState>();

  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: AppColors.primaryWhite,
      title: const Text(AppTexts.addRegion),
      content: Form(
        key: formKey,
        child: TextFormField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(labelText: AppTexts.nameRegion),
          validator: (value) {
            final text = value?.trim() ?? '';
            if (text.isEmpty) return AppTexts.addNameRegion;
            final st = context.read<RegionCubit>().state;
            final regions = st is RegionLoaded
                ? st.regions
                : (st is RegionError ? st.previousRegions : <RegionEntity>[]);
            if (regions.any(
              (r) => r.name.toLowerCase() == text.toLowerCase(),
            )) {
              return AppTexts.regionExist;
            }
            return null;
          },
        ),
      ),
      actions: [
        HoverButton(
          onPressed: () => Navigator.pop(dialogContext),
          color: AppColors.backgroundButtonRed,
          child: const Text(
            AppTexts.cancel,
            style: TextStyle(color: AppColors.textButtonWhite),
          ),
        ),
        HoverButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              context.read<RegionCubit>().addRegion(
                RegionEntity(id: 0, name: controller.text.trim()),
              );
              Navigator.pop(dialogContext);
            }
          },
          child: const Text(
            AppTexts.add,
            style: TextStyle(color: AppColors.textButtonWhite),
          ),
        ),
      ],
    ),
  );
}
