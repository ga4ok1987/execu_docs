// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:execu_docs/data/datasources/local/database.dart' as _i914;
import 'package:execu_docs/data/datasources/local/region_dao.dart' as _i269;
import 'package:execu_docs/data/repositories_impl/region_repository_impl.dart'
    as _i11;
import 'package:execu_docs/domain/repositories/region_repository.dart' as _i35;
import 'package:execu_docs/domain/usecases/add_region_usacase.dart' as _i602;
import 'package:execu_docs/domain/usecases/del_region_usecase.dart' as _i280;
import 'package:execu_docs/domain/usecases/get_all_region_usecase.dart'
    as _i826;
import 'package:execu_docs/domain/usecases/seed_regions_usecase.dart' as _i268;
import 'package:execu_docs/domain/usecases/update_executor_offices_usecase.dart'
    as _i609;
import 'package:execu_docs/domain/usecases/update_region_name_usecase.dart'
    as _i231;
import 'package:execu_docs/presentation/blocs/folder_cubit.dart' as _i880;
import 'package:execu_docs/presentation/blocs/panels_cubit.dart' as _i642;
import 'package:execu_docs/presentation/blocs/region_cubit.dart' as _i100;
import 'package:execu_docs/presentation/blocs/region_selection_cubit.dart'
    as _i1028;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i880.FolderCubit>(() => _i880.FolderCubit());
    gh.factory<_i642.PanelsCubit>(() => _i642.PanelsCubit());
    gh.factory<_i1028.RegionSelectionCubit>(
      () => _i1028.RegionSelectionCubit(),
    );
    gh.lazySingleton<_i914.AppDatabase>(() => _i914.AppDatabase());
    gh.lazySingleton<_i269.RegionDao>(
      () => _i269.RegionDao(gh<_i914.AppDatabase>()),
    );
    gh.lazySingleton<_i35.RegionRepository>(
      () => _i11.RegionRepositoryImpl(gh<_i269.RegionDao>()),
    );
    gh.factory<_i602.AddRegionUseCase>(
      () => _i602.AddRegionUseCase(gh<_i35.RegionRepository>()),
    );
    gh.factory<_i280.DelRegionUseCase>(
      () => _i280.DelRegionUseCase(gh<_i35.RegionRepository>()),
    );
    gh.factory<_i826.GetAllRegionsUseCase>(
      () => _i826.GetAllRegionsUseCase(gh<_i35.RegionRepository>()),
    );
    gh.factory<_i268.SeedRegionsUseCase>(
      () => _i268.SeedRegionsUseCase(gh<_i35.RegionRepository>()),
    );
    gh.factory<_i609.UpdateExecutorOfficesUseCase>(
      () => _i609.UpdateExecutorOfficesUseCase(gh<_i35.RegionRepository>()),
    );
    gh.factory<_i231.UpdateRegionNameUseCase>(
      () => _i231.UpdateRegionNameUseCase(gh<_i35.RegionRepository>()),
    );
    gh.factory<_i100.RegionCubit>(
      () => _i100.RegionCubit(
        getAllRegionsUseCase: gh<_i826.GetAllRegionsUseCase>(),
        deleteRegionUseCase: gh<_i280.DelRegionUseCase>(),
        addRegionUseCase: gh<_i602.AddRegionUseCase>(),
        updateRegionUseCase: gh<_i609.UpdateExecutorOfficesUseCase>(),
        updateRegionNameUseCase: gh<_i231.UpdateRegionNameUseCase>(),
      ),
    );
    return this;
  }
}
