// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../features/activities/data/datasources/data_sources_contracts.dart'
    as _i5;
import '../features/activities/data/datasources/drift/drift_db.dart' as _i6;
import '../features/activities/data/repositories/activity_repository_impl.dart'
    as _i8;
import '../features/activities/domain/repositories/activity_repository.dart'
    as _i7;
import '../features/activities/domain/usecases/activities_usecases.dart' as _i4;
import '../features/activities/domain/usecases/add_emoji_usecase.dart' as _i9;
import '../features/activities/domain/usecases/edit_name_usecase.dart' as _i10;
import '../features/activities/domain/usecases/insert_activity_usecase.dart'
    as _i11;
import '../features/activities/domain/usecases/load_activities_usecase.dart'
    as _i12;
import '../features/activities/domain/usecases/switch_activities_usecase.dart'
    as _i13;
import '../features/activities/presentation/bloc/activities_bloc.dart'
    as _i3; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  gh.factory<_i3.ActivitiesBloc>(() => _i3.ActivitiesBloc(
      loadActivitiesUsecase: get<_i4.LoadActivitiesUsecase>(),
      switchActivityUsecase: get<_i4.SwitchActivitiesUsecase>(),
      addEmojiUsecase: get<_i4.AddEmojiUsecase>(),
      editNameUsecase: get<_i4.EditNameUsecase>(),
      insertActivityUsecase: get<_i4.InsertActivityUsecase>()));
  gh.lazySingleton<_i5.ActivityLocalDataSource>(() => _i6.ActivityDatabase());
  gh.lazySingleton<_i7.ActivityRepository>(() => _i8.ActivityRepositoryImpl(
      localDataSource: get<_i5.ActivityLocalDataSource>()));
  gh.lazySingleton<_i9.AddEmojiUsecase>(
      () => _i9.AddEmojiUsecase(get<_i7.ActivityRepository>()));
  gh.lazySingleton<_i10.EditNameUsecase>(
      () => _i10.EditNameUsecase(get<_i7.ActivityRepository>()));
  gh.lazySingleton<_i11.InsertActivityUsecase>(
      () => _i11.InsertActivityUsecase(get<_i7.ActivityRepository>()));
  gh.lazySingleton<_i12.LoadActivitiesUsecase>(
      () => _i12.LoadActivitiesUsecase(get<_i7.ActivityRepository>()));
  gh.lazySingleton<_i13.SwitchActivitiesUsecase>(
      () => _i13.SwitchActivitiesUsecase(get<_i7.ActivityRepository>()));
  return get;
}
