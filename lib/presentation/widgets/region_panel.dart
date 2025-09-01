import 'package:execu_docs/core/widgets/hover_button.dart';
import 'package:execu_docs/presentation/widgets/region_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../domain/entities/region_entity.dart';
import '../blocs/region_cubit.dart';
import 'dialogs/add_region_dialog.dart';
import 'package:execu_docs/core/constants/index.dart';

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
              backgroundColor: AppColors.primaryWhite,

              title: const Text(AppTexts.error),
              content: Text(state.message),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    AppTexts.ok,
                    style: TextStyle(color: AppColors.textButtonWhite),
                  ),
                ),
              ],
            ),
          );
        }
      },
      child: Column(
        children: [
          Container(
            height: AppSizes.appBarHeight,
            color: AppColors.primaryWhite,
            padding: AppPadding.horizontal16,
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  AppTexts.regions,
                  style: TextStyle(
                    color: AppColors.primaryDarkMain,
                    fontSize: AppTextSizes.big,
                  ),
                ),
                BlocBuilder<RegionCubit, RegionState>(
                  builder: (context, state) {
                    if (state is RegionLoading) {
                      return const SizedBox(child: CircularProgressIndicator());
                    }
                    return HoverButton(
                      isCircle: true,
                      onPressed: () => addRegionDialog(context),
                      child: const Icon(
                        Icons.add,
                        color: AppColors.primaryWhite,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: AppColors.primaryWhite,
              child: BlocBuilder<RegionCubit, RegionState>(
                builder: (context, state) {
                  List<RegionEntity> regions = [];
                  if (state is RegionLoaded) regions = state.regions;
                  if (state is RegionError) regions = state.previousRegions;

                  if (regions.isEmpty) {
                    if (state is RegionLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return const Center(child: Text(AppTexts.noRegions));
                  }

                  return SlidableAutoCloseBehavior(
                    child: ListView.separated(
                      itemCount: regions.length,
                      itemBuilder: (context, index) =>
                          RegionTile(region: regions[index]),
                      separatorBuilder: (_, __) =>
                          Divider(height: 0, color: AppColors.dividerMain),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
