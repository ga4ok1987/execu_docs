import 'package:execu_docs/data/repositories_impl/region_repository_impl.dart';
import 'package:execu_docs/presentation/blocs/folder_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'core/constants/uk_regions.dart';
import 'core/di/di.dart';
import 'core/router.dart';
import 'data/datasources/local/database.dart';
import 'data/datasources/local/region_dao.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = AppDatabase();
  final regionDao = RegionDao(db);
  await RegionRepositoryImpl(regionDao).seedRegions(ukrainianRegions);

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );
  await configureDependencies();
  runApp(const AppWrapper());

}

class AppWrapper extends StatelessWidget {
  const AppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FolderCubit>(create: (_) => getIt<FolderCubit>()),

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
      routerConfig: router,
      title: 'Violation App',
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}
