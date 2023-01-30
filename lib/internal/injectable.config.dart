// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:copilot/features/activities/data/datasources/data_sources_contracts.dart'
    as _i3;
import 'package:copilot/features/activities/data/datasources/drift/drift_db.dart'
    as _i4;
import 'package:copilot/features/activities/data/repositories/activity_repository_impl.dart'
    as _i6;
import 'package:copilot/features/activities/domain/repositories/activity_repository.dart'
    as _i5;
import 'package:copilot/features/activities/domain/usecases/activities_usecases.dart'
    as _i13;
import 'package:copilot/features/activities/domain/usecases/add_emoji_usecase.dart'
    as _i7;
import 'package:copilot/features/activities/domain/usecases/edit_name_usecase.dart'
    as _i8;
import 'package:copilot/features/activities/domain/usecases/insert_activity_usecase.dart'
    as _i9;
import 'package:copilot/features/activities/domain/usecases/load_activities_usecase.dart'
    as _i10;
import 'package:copilot/features/activities/domain/usecases/switch_activities_usecase.dart'
    as _i11;
import 'package:copilot/features/activities/presentation/bloc/activities_bloc.dart'
    as _i12;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

/// ignore_for_file: unnecessary_lambdas
/// ignore_for_file: lines_longer_than_80_chars
extension GetItInjectableX on _i1.GetIt {
  /// initializes the registration of main-scope dependencies inside of [GetIt]
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.lazySingleton<_i3.ActivityLocalDataSource>(() => _i4.ActivityDatabase());
    gh.lazySingleton<_i5.ActivityRepository>(() => _i6.ActivityRepositoryImpl(
        localDataSource: gh<_i3.ActivityLocalDataSource>()));
    gh.lazySingleton<_i7.AddEmojiUsecase>(
        () => _i7.AddEmojiUsecase(gh<_i5.ActivityRepository>()));
    gh.lazySingleton<_i8.EditNameUsecase>(
        () => _i8.EditNameUsecase(gh<_i5.ActivityRepository>()));
    gh.lazySingleton<_i9.InsertActivityUsecase>(
        () => _i9.InsertActivityUsecase(gh<_i5.ActivityRepository>()));
    gh.lazySingleton<_i10.LoadActivitiesUsecase>(
        () => _i10.LoadActivitiesUsecase(gh<_i5.ActivityRepository>()));
    gh.lazySingleton<_i11.SwitchActivitiesUsecase>(
        () => _i11.SwitchActivitiesUsecase(gh<_i5.ActivityRepository>()));
    gh.factory<_i12.ActivitiesBloc>(() => _i12.ActivitiesBloc(
          loadActivitiesUsecase: gh<_i13.LoadActivitiesUsecase>(),
          switchActivityUsecase: gh<_i13.SwitchActivitiesUsecase>(),
          addEmojiUsecase: gh<_i13.AddEmojiUsecase>(),
          editNameUsecase: gh<_i13.EditNameUsecase>(),
          insertActivityUsecase: gh<_i13.InsertActivityUsecase>(),
        ));
    return this;
  }
}
