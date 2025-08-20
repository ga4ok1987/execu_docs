import 'package:execu_docs/domain/usecases/add_debtor_usecase.dart';
import 'package:execu_docs/domain/usecases/claer_debtors_usecase.dart';
import 'package:execu_docs/domain/usecases/delete_debtor_usecase.dart';
import 'package:execu_docs/domain/usecases/get_debtors_usecase.dart';
import 'package:execu_docs/domain/usecases/update_debtor_usecase.dart';
import 'package:execu_docs/presentation/blocs/debtor_cubit.dart';
import 'package:execu_docs/presentation/blocs/folder_cubit.dart';
import 'package:execu_docs/presentation/blocs/panels_cubit.dart';
import 'package:execu_docs/presentation/blocs/region_cubit.dart';
import 'package:execu_docs/presentation/blocs/region_selection_cubit.dart';
import 'package:execu_docs/presentation/blocs/windows_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'core/constants/colors.dart';
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
  WindowCubit().init();

  runApp(const AppWrapper());
}

class AppWrapper extends StatelessWidget {
  const AppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<WindowCubit>(create: (_) => getIt<WindowCubit>()),
        BlocProvider<FolderCubit>(create: (_) => getIt<FolderCubit>()),
        BlocProvider<RegionCubit>(
          create: (context) => RegionCubit(
            getAllRegionsUseCase: getIt<GetAllRegionsUseCase>(),
            deleteRegionUseCase: getIt<DelRegionUseCase>(),
            addRegionUseCase: getIt<AddRegionUseCase>(),
            updateRegionNameUseCase: getIt<UpdateRegionNameUseCase>(),
          )..loadRegions(),
        ),
        BlocProvider<DebtorCubit>(
          create: (context) => DebtorCubit(
            addDebtorUseCase: getIt<AddDebtorUseCase>(),
            updateDebtorUseCase: getIt<UpdateDebtorUseCase>(),
            deleteDebtorUseCase: getIt<DeleteDebtorUseCase>(),
            getDebtorsUseCase: getIt<GetDebtorsUseCase>(),
            getAllRegionsUseCase: getIt<GetAllRegionsUseCase>(),
            clearDebtorsUseCase: getIt<ClearDebtorsUseCase>(),
          )..loadDebtors(),
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
      theme: ThemeData(
        dividerColor: Colors.transparent,
        brightness: Brightness.light,
        primaryColor: Colors.white,
        scaffoldBackgroundColor: AppColors.backgroundColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 18, color: Colors.black87),
          bodyMedium: TextStyle(fontSize: 16, color: Colors.black54),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ),
    );
  }
}
