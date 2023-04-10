// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:copilot/core/common/data/datasources/drift_db.dart' as _i4;
import 'package:copilot/features/activities/data/datasources/data_sources_contracts.dart'
    as _i3;
import 'package:copilot/features/activities/data/repositories/activity_repository_impl.dart'
    as _i6;
import 'package:copilot/features/activities/domain/repositories/activity_repository.dart'
    as _i5;
import 'package:copilot/features/activities/domain/usecases/activities_usecases.dart'
    as _i19;
import 'package:copilot/features/activities/domain/usecases/add_emoji_usecase.dart'
    as _i7;
import 'package:copilot/features/activities/domain/usecases/edit_name_usecase.dart'
    as _i8;
import 'package:copilot/features/activities/domain/usecases/edit_records_usecase.dart'
    as _i9;
import 'package:copilot/features/activities/domain/usecases/load_activities_usecase.dart'
    as _i12;
import 'package:copilot/features/activities/domain/usecases/switch_activities_usecase.dart'
    as _i16;
import 'package:copilot/features/activities/presentation/bloc/activities_bloc.dart'
    as _i18;
import 'package:copilot/features/firebase/data/datasources/sync_local_datasource.dart'
    as _i15;
import 'package:copilot/features/firebase/data/repositories/firebase_auth_repository_impl.dart'
    as _i11;
import 'package:copilot/features/firebase/data/repositories/local_sync_repository_impl.dart'
    as _i14;
import 'package:copilot/features/firebase/domain/repositories/firebase_auth_repository.dart'
    as _i10;
import 'package:copilot/features/firebase/domain/repositories/local_sync_repository.dart'
    as _i13;
import 'package:copilot/features/firebase/domain/usecases/auth_usecase.dart'
    as _i20;
import 'package:copilot/features/firebase/domain/usecases/sync_usecase.dart'
    as _i17;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

extension GetItInjectableX on _i1.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
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
    gh.lazySingleton<_i9.EditRecordsUsecase>(
        () => _i9.EditRecordsUsecase(gh<_i5.ActivityRepository>()));
    gh.lazySingleton<_i10.FirebaseAuthRepository>(
        () => _i11.FirebaseAuthRepositoryImpl());
    gh.lazySingleton<_i12.LoadActivitiesUsecase>(
        () => _i12.LoadActivitiesUsecase(gh<_i5.ActivityRepository>()));
    gh.lazySingleton<_i13.LocalSyncRepository>(
        () => _i14.LocalSyncRepositoryImpl(gh<_i15.SyncLocalDataSource>()));
    gh.lazySingleton<_i16.SwitchActivitiesUsecase>(
        () => _i16.SwitchActivitiesUsecase(gh<_i5.ActivityRepository>()));
    gh.lazySingleton<_i17.SyncUsecase>(() => _i17.SyncUsecase(
          gh<_i13.LocalSyncRepository>(),
          gh<_i10.FirebaseAuthRepository>(),
        ));
    gh.factory<_i18.ActivitiesBloc>(() => _i18.ActivitiesBloc(
          loadActivitiesUsecase: gh<_i19.LoadActivitiesUsecase>(),
          switchActivityUsecase: gh<_i19.SwitchActivitiesUsecase>(),
          addEmojiUsecase: gh<_i19.AddEmojiUsecase>(),
          editNameUsecase: gh<_i19.EditNameUsecase>(),
          editRecordsUsecase: gh<_i19.EditRecordsUsecase>(),
        ));
    gh.lazySingleton<_i20.AuthUsecase>(
        () => _i20.AuthUsecase(gh<_i10.FirebaseAuthRepository>()));
    return this;
  }
}
