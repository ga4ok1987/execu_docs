import 'package:execu_docs/presentation/screens/data_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../domain/usecases/add_region_usacase.dart';
import '../domain/usecases/del_region_usecase.dart';
import '../domain/usecases/get_all_region_usecase.dart';
import '../domain/usecases/update_executor_offices_usecase.dart';
import '../presentation/blocs/region_cubit.dart';
import '../presentation/screens/main_page.dart';
import 'constants/routes.dart';
import 'di/di.dart'; // Якщо є getIt, підключай його тут

final router = GoRouter(
  routes: [
    GoRoute(
      path: Routes.root,
      builder: (BuildContext context, GoRouterState state) => MainPage(),
      routes: [
        GoRoute(
          path: 'data',
          name: 'data',
          builder: (context, state) {
            return BlocProvider(
              create: (_) => RegionCubit(
                getAllRegionsUseCase: getIt<GetAllRegionsUseCase>(),
                deleteRegionUseCase: getIt<DelRegionUseCase>(),
                addRegionUseCase: getIt<AddRegionUseCase>(),
                updateRegionUseCase: getIt<UpdateExecutorOfficesUseCase>(),
              )..loadRegions(),
              child: const DataPage(),
            );
          },
        ),
      ],
    ),
  ],
);
