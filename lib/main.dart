import 'package:execu_docs/presentation/blocs/folder_cubit.dart';
import 'package:execu_docs/presentation/blocs/panels_cubit.dart';
import 'package:execu_docs/presentation/blocs/region_cubit.dart';
import 'package:execu_docs/presentation/blocs/region_selection_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'core/constants/uk_regions.dart';
import 'core/di/di.dart';
import 'core/router.dart';
import 'domain/usecases/add_region_usacase.dart';
import 'domain/usecases/del_region_usecase.dart';
import 'domain/usecases/get_all_region_usecase.dart';
import 'domain/usecases/seed_regions_usecase.dart';
import 'domain/usecases/update_region_name_usecase.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );
  await configureDependencies();
  final regionRepo = getIt<SeedRegionsUseCase>();
  await regionRepo.call(ukrainianRegions);
  runApp(const AppWrapper());
}

class AppWrapper extends StatelessWidget {
  const AppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FolderCubit>(create: (_) => getIt<FolderCubit>()),
        BlocProvider<RegionCubit>(
          create: (context) => RegionCubit(
            getAllRegionsUseCase: getIt<GetAllRegionsUseCase>(),
            deleteRegionUseCase: getIt<DelRegionUseCase>(),
            addRegionUseCase: getIt<AddRegionUseCase>(),
            updateRegionNameUseCase: getIt<UpdateRegionNameUseCase>(),
          )..loadRegions(),
        ),

        BlocProvider<RegionSelectionCubit>(
          create: (_) => getIt<RegionSelectionCubit>(),
        ),
        BlocProvider<PanelsCubit>(create: (_) => getIt<PanelsCubit>()),
      ],

      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      title: 'Violation App',
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}
