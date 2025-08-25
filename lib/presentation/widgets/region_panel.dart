import 'package:execu_docs/core/widgets/hover_button.dart';
import 'package:execu_docs/presentation/widgets/region_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../domain/entities/region_entity.dart';
import '../blocs/region_cubit.dart';
import 'dialogs/add_region_dialog.dart';

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
            builder: (_) =>
                AlertDialog(
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
          toolbarHeight: 90,

          title: const Text('Області', style: TextStyle(color: Colors.black),),
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
                  child: HoverButton(
                    isCircle: true,
                    onPressed: () => addRegionDialog(context),
                    child: const Icon(Icons.add),
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
              if (state is RegionLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return const Center(child: Text('Регіони не додані'));
            }

            return SlidableAutoCloseBehavior(
              child: ListView.separated(
                itemCount: regions.length,
                itemBuilder: (context, index) =>
                    RegionTile(region: regions[index]),
                separatorBuilder: (_, __) =>
                    Divider(height: 0, color: Colors.grey.shade300),
              ),
            );
          },
        ),
      ),
    );
  }
}

