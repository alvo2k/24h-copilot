// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:copilot/core/common/data/datasources/activity_database.dart'
    as _i4;
import 'package:copilot/core/common/data/datasources/activity_local_data_source.dart'
    as _i3;
import 'package:copilot/features/activities/data/repositories/activity_repository_impl.dart'
    as _i6;
import 'package:copilot/features/activities/domain/repositories/activity_repository.dart'
    as _i5;
import 'package:copilot/features/activities/domain/usecases/activities_usecases.dart'
    as _i20;
import 'package:copilot/features/activities/domain/usecases/add_emoji_usecase.dart'
    as _i9;
import 'package:copilot/features/activities/domain/usecases/edit_name_usecase.dart'
    as _i10;
import 'package:copilot/features/activities/domain/usecases/edit_records_usecase.dart'
    as _i11;
import 'package:copilot/features/activities/domain/usecases/load_activities_usecase.dart'
    as _i13;
import 'package:copilot/features/activities/domain/usecases/switch_activities_usecase.dart'
    as _i17;
import 'package:copilot/features/activities/presentation/bloc/activities_bloc.dart'
    as _i19;
import 'package:copilot/features/card-editor/data/repositories/activity_settings_repository_impl.dart'
    as _i8;
import 'package:copilot/features/card-editor/domain/repositories/activity_settings_repository.dart'
    as _i7;
import 'package:copilot/features/card-editor/domain/usecases/load_activities_settings_usecase.dart'
    as _i12;
import 'package:copilot/features/card-editor/domain/usecases/update_activity_settings_usecase.dart'
    as _i18;
import 'package:copilot/features/dashboard/data/repositories/pie_chart_data_repository_impl.dart'
    as _i15;
import 'package:copilot/features/dashboard/domain/repositories/pie_chart_data_repositoty.dart'
    as _i14;
import 'package:copilot/features/dashboard/domain/usecases/pie_chart_data_usecase.dart'
    as _i16;
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
    gh.lazySingleton<_i5.ActivityRepository>(
        () => _i6.ActivityRepositoryImpl(gh<_i3.ActivityLocalDataSource>()));
    gh.lazySingleton<_i7.ActivitySettingsRepository>(() =>
        _i8.ActivitySettingsRepositoryImpl(gh<_i3.ActivityLocalDataSource>()));
    gh.lazySingleton<_i9.AddEmojiUsecase>(
        () => _i9.AddEmojiUsecase(gh<_i5.ActivityRepository>()));
    gh.lazySingleton<_i10.EditNameUsecase>(
        () => _i10.EditNameUsecase(gh<_i5.ActivityRepository>()));
    gh.lazySingleton<_i11.EditRecordsUsecase>(
        () => _i11.EditRecordsUsecase(gh<_i5.ActivityRepository>()));
    gh.lazySingleton<_i12.LoadActivitiesSettingsUsecase>(() =>
        _i12.LoadActivitiesSettingsUsecase(
            gh<_i7.ActivitySettingsRepository>()));
    gh.lazySingleton<_i13.LoadActivitiesUsecase>(
        () => _i13.LoadActivitiesUsecase(gh<_i5.ActivityRepository>()));
    gh.lazySingleton<_i14.PieChartDataRepository>(() =>
        _i15.PieChartDataRepositoryImpl(gh<_i3.ActivityLocalDataSource>()));
    gh.lazySingleton<_i16.PieChartDataUsecase>(
        () => _i16.PieChartDataUsecase(gh<_i14.PieChartDataRepository>()));
    gh.lazySingleton<_i17.SwitchActivitiesUsecase>(
        () => _i17.SwitchActivitiesUsecase(gh<_i5.ActivityRepository>()));
    gh.lazySingleton<_i18.UpdateActivitySettingsUsecase>(() =>
        _i18.UpdateActivitySettingsUsecase(
            gh<_i7.ActivitySettingsRepository>()));
    gh.factory<_i19.ActivitiesBloc>(() => _i19.ActivitiesBloc(
          loadActivitiesUsecase: gh<_i20.LoadActivitiesUsecase>(),
          switchActivityUsecase: gh<_i20.SwitchActivitiesUsecase>(),
          addEmojiUsecase: gh<_i20.AddEmojiUsecase>(),
          editNameUsecase: gh<_i20.EditNameUsecase>(),
          editRecordsUsecase: gh<_i20.EditRecordsUsecase>(),
        ));
    return this;
  }
}
