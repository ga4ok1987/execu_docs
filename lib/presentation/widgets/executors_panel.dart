import 'package:execu_docs/core/widgets/hover_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/region_entity.dart';
import '../blocs/executor_office_cubit.dart';
import '../blocs/region_selection_cubit.dart';
import 'dialogs/add_executor_dialog.dart';
import 'executor_tile.dart';

class ExecutorsPanel extends StatelessWidget {
  final RegionEntity region;

  const ExecutorsPanel({super.key, required this.region});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,

        backgroundColor: Colors.white,
        title: Text(
          'Виконавчі служби регіону ${region.name}',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          BlocBuilder<ExecutorCubit, ExecutorState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: HoverButton(
                  isCircle: true,
                  onPressed: () =>
                      addExecutorDialog(context, context.read<ExecutorCubit>()),
                  child: const Icon(Icons.add),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: HoverButton(
              isCircle: true,
              onPressed: () => context.read<RegionSelectionCubit>().clear(),
              child: const Icon(Icons.close),
            ),
          ),
        ],
      ),
      body: BlocBuilder<ExecutorCubit, ExecutorState>(
        builder: (context, state) {
          if (state is ExecutorLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ExecutorError) {
            return Center(child: Text('Помилка: ${state.message}'));
          } else if (state is ExecutorLoaded) {
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
    );
  }


}
