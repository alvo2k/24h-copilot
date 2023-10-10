// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:copilot/core/app_router.dart' as _i10;
import 'package:copilot/core/common/data/datasources/activity_database.dart'
    as _i4;
import 'package:copilot/core/common/data/datasources/activity_local_data_source.dart'
    as _i3;
import 'package:copilot/core/notification_controller.dart' as _i15;
import 'package:copilot/features/activities/data/repositories/activity_repository_impl.dart'
    as _i6;
import 'package:copilot/features/activities/domain/repositories/activity_repository.dart'
    as _i5;
import 'package:copilot/features/activities/domain/usecases/activities_usecases.dart'
    as _i22;
import 'package:copilot/features/activities/domain/usecases/add_emoji_usecase.dart'
    as _i9;
import 'package:copilot/features/activities/domain/usecases/edit_name_usecase.dart'
    as _i11;
import 'package:copilot/features/activities/domain/usecases/edit_records_usecase.dart'
    as _i12;
import 'package:copilot/features/activities/domain/usecases/load_activities_usecase.dart'
    as _i14;
import 'package:copilot/features/activities/domain/usecases/switch_activities_usecase.dart'
    as _i19;
import 'package:copilot/features/activities/presentation/bloc/activities_bloc.dart'
    as _i21;
import 'package:copilot/features/card-editor/data/repositories/activity_settings_repository_impl.dart'
    as _i8;
import 'package:copilot/features/card-editor/domain/repositories/activity_settings_repository.dart'
    as _i7;
import 'package:copilot/features/card-editor/domain/usecases/load_activities_settings_usecase.dart'
    as _i13;
import 'package:copilot/features/card-editor/domain/usecases/update_activity_settings_usecase.dart'
    as _i20;
import 'package:copilot/features/dashboard/data/repositories/pie_chart_data_repository_impl.dart'
    as _i17;
import 'package:copilot/features/dashboard/domain/repositories/pie_chart_data_repositoty.dart'
    as _i16;
import 'package:copilot/features/dashboard/domain/usecases/pie_chart_data_usecase.dart'
    as _i18;
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
    gh.singleton<_i10.AppRouter>(_i10.AppRouter());
    gh.lazySingleton<_i11.EditNameUsecase>(
        () => _i11.EditNameUsecase(gh<_i5.ActivityRepository>()));
    gh.lazySingleton<_i12.EditRecordsUsecase>(
        () => _i12.EditRecordsUsecase(gh<_i5.ActivityRepository>()));
    gh.lazySingleton<_i13.LoadActivitiesSettingsUsecase>(() =>
        _i13.LoadActivitiesSettingsUsecase(
            gh<_i7.ActivitySettingsRepository>()));
    gh.lazySingleton<_i14.LoadActivitiesUsecase>(
        () => _i14.LoadActivitiesUsecase(gh<_i5.ActivityRepository>()));
    gh.singleton<_i15.NotificationController>(_i15.NotificationController());
    gh.lazySingleton<_i16.PieChartDataRepository>(() =>
        _i17.PieChartDataRepositoryImpl(gh<_i3.ActivityLocalDataSource>()));
    gh.lazySingleton<_i18.PieChartDataUsecase>(
        () => _i18.PieChartDataUsecase(gh<_i16.PieChartDataRepository>()));
    gh.lazySingleton<_i19.SwitchActivitiesUsecase>(
        () => _i19.SwitchActivitiesUsecase(gh<_i5.ActivityRepository>()));
    gh.lazySingleton<_i20.UpdateActivitySettingsUsecase>(() =>
        _i20.UpdateActivitySettingsUsecase(
            gh<_i7.ActivitySettingsRepository>()));
    gh.factory<_i21.ActivitiesBloc>(() => _i21.ActivitiesBloc(
          loadActivitiesUsecase: gh<_i22.LoadActivitiesUsecase>(),
          switchActivityUsecase: gh<_i22.SwitchActivitiesUsecase>(),
          addEmojiUsecase: gh<_i22.AddEmojiUsecase>(),
          editNameUsecase: gh<_i22.EditNameUsecase>(),
          editRecordsUsecase: gh<_i22.EditRecordsUsecase>(),
        ));
    return this;
  }
}
