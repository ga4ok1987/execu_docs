import 'package:execu_docs/core/constants/app_border_radius.dart';
import 'package:execu_docs/presentation/blocs/debtor_cubit.dart';
import 'package:execu_docs/presentation/blocs/debtor_sort_cubit.dart';
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
import 'core/constants/app_colors.dart';
import 'core/constants/uk_regions.dart';
import 'core/di/di.dart';
import 'core/router.dart';
import 'domain/usecases/debtors_crud_usecases.dart';
import 'domain/usecases/regions_crud_usecase.dart';
import 'domain/usecases/seed_regions_usecase.dart';

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
        BlocProvider<DebtorSortCubit>(create: (_) => getIt<DebtorSortCubit>()),
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
        dividerColor: AppColors.transparent,
        brightness: Brightness.light,
        primaryColor: AppColors.primaryWhite,
        scaffoldBackgroundColor: AppColors.backgroundColor,
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: AppColors.primaryMainBlue),
          filled: true,
          fillColor: AppColors.primaryWhite,
          border: OutlineInputBorder(
            borderRadius: AppBorderRadius.all12,
            borderSide: BorderSide(color: AppColors.primaryMainBlue, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppBorderRadius.all12,
            borderSide: BorderSide(color: AppColors.primaryMainBlue, width: 2), // не активне
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppBorderRadius.all12,
            borderSide: BorderSide(color: AppColors.primaryMainBlue, width: 2), // активне поле
          ),


        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: AppColors.primaryMainBlue, // глобальний колір курсора
          selectionColor: AppColors.primaryMainBlue, // виділення тексту
          selectionHandleColor: AppColors.primaryMainBlue, // ручки виділення
        ),

      ),
    );
  }
}
