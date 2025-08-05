import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/region_selection_cubit.dart';

class ExecutorOfficesPanel extends StatelessWidget {
  final int? regionId;

  const ExecutorOfficesPanel({super.key, required this.regionId});

  @override
  Widget build(BuildContext context) {
    if (regionId == null) return const SizedBox();

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Text('Виконавчі служби регіону #$regionId', style: Theme.of(context).textTheme.titleLarge),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => context.read<RegionSelectionCubit>().clear(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Expanded(
            child: Center(
              child: Text('Тут буде список виконавчих служб'),
            ),
          ),
        ],
      ),
    );
  }
}
