import 'package:execu_docs/core/widgets/hover_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/region_entity.dart';
import '../blocs/executor_office_cubit.dart';
import '../blocs/region_selection_cubit.dart';
import 'dialogs/add_executor_dialog.dart';
import 'executor_tile.dart';
import 'package:execu_docs/core/constants/index.dart';

class ExecutorsPanel extends StatelessWidget {
  final RegionEntity region;

  const ExecutorsPanel({super.key, required this.region});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: AppSizes.appBarHeight,
          color: AppColors.primaryWhite,
          padding: AppPadding.horizontal16,
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppTexts.executorsInRegion(region.name),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Spacer(),
              BlocBuilder<ExecutorCubit, ExecutorState>(
                builder: (context, state) {
                  if (state is ExecutorLoading) {
                    return const SizedBox(child: CircularProgressIndicator());
                  }
                  return Padding(
                    padding: AppPadding.all8,
                    child: HoverButton(
                      isCircle: true,
                      onPressed: () => addExecutorDialog(
                        context,
                        context.read<ExecutorCubit>(),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: AppColors.primaryWhite,
                      ),
                    ),
                  );
                },
              ),
              Padding(
                padding: AppPadding.all8,
                child: HoverButton(
                  isCircle: true,
                  onPressed: () => context.read<RegionSelectionCubit>().clear(),
                  child: const Icon(Icons.close, color: AppColors.primaryWhite),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            color: AppColors.primaryWhite,

            child: BlocBuilder<ExecutorCubit, ExecutorState>(
              builder: (context, state) {
                if (state is ExecutorLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ExecutorError) {
                  return Center(child: Text(AppTexts.error));
                } else if (state is ExecutorLoaded) {
                  if (state.offices.isEmpty) {
                    return const Center(
                      child: Text(AppTexts.executorsNotFound),
                    );
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
        ),
      ],
    );
  }
}
