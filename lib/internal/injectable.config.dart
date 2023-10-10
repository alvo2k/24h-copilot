// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:copilot/core/app_router.dart' as _i7;
import 'package:copilot/core/common/data/datasources/activity_database.dart'
    as _i4;
import 'package:copilot/core/common/data/datasources/activity_local_data_source.dart'
    as _i3;
import 'package:copilot/core/notification_controller.dart' as _i9;
import 'package:copilot/features/activities/data/datasources/recommended_activities_data_source.dart'
    as _i13;
import 'package:copilot/features/activities/data/repositories/activity_repository_impl.dart'
    as _i16;
import 'package:copilot/features/activities/domain/repositories/activity_repository.dart'
    as _i15;
import 'package:copilot/features/activities/domain/usecases/activities_usecases.dart'
    as _i24;
import 'package:copilot/features/activities/domain/usecases/add_emoji_usecase.dart'
    as _i17;
import 'package:copilot/features/activities/domain/usecases/edit_name_usecase.dart'
    as _i18;
import 'package:copilot/features/activities/domain/usecases/edit_records_usecase.dart'
    as _i19;
import 'package:copilot/features/activities/domain/usecases/load_activities_usecase.dart'
    as _i20;
import 'package:copilot/features/activities/domain/usecases/recommended_activities_usecase.dart'
    as _i21;
import 'package:copilot/features/activities/domain/usecases/switch_activities_usecase.dart'
    as _i22;
import 'package:copilot/features/activities/presentation/bloc/activities_bloc.dart'
    as _i23;
import 'package:copilot/features/card-editor/data/repositories/activity_settings_repository_impl.dart'
    as _i6;
import 'package:copilot/features/card-editor/domain/repositories/activity_settings_repository.dart'
    as _i5;
import 'package:copilot/features/card-editor/domain/usecases/load_activities_settings_usecase.dart'
    as _i8;
import 'package:copilot/features/card-editor/domain/usecases/update_activity_settings_usecase.dart'
    as _i14;
import 'package:copilot/features/dashboard/data/repositories/pie_chart_data_repository_impl.dart'
    as _i11;
import 'package:copilot/features/dashboard/domain/repositories/pie_chart_data_repositoty.dart'
    as _i10;
import 'package:copilot/features/dashboard/domain/usecases/pie_chart_data_usecase.dart'
    as _i12;
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
    gh.lazySingleton<_i5.ActivitySettingsRepository>(() =>
        _i6.ActivitySettingsRepositoryImpl(gh<_i3.ActivityLocalDataSource>()));
    gh.singleton<_i7.AppRouter>(_i7.AppRouter());
    gh.lazySingleton<_i8.LoadActivitiesSettingsUsecase>(() =>
        _i8.LoadActivitiesSettingsUsecase(
            gh<_i5.ActivitySettingsRepository>()));
    gh.singleton<_i9.NotificationController>(_i9.NotificationController());
    gh.lazySingleton<_i10.PieChartDataRepository>(() =>
        _i11.PieChartDataRepositoryImpl(gh<_i3.ActivityLocalDataSource>()));
    gh.lazySingleton<_i12.PieChartDataUsecase>(
        () => _i12.PieChartDataUsecase(gh<_i10.PieChartDataRepository>()));
    gh.lazySingleton<_i13.RecommendedActivitiesDataSource>(
        () => _i13.RecommendedActivitiesDataSourceImpl());
    gh.lazySingleton<_i14.UpdateActivitySettingsUsecase>(() =>
        _i14.UpdateActivitySettingsUsecase(
            gh<_i5.ActivitySettingsRepository>()));
    gh.lazySingleton<_i15.ActivityRepository>(() => _i16.ActivityRepositoryImpl(
          gh<_i3.ActivityLocalDataSource>(),
          gh<_i13.RecommendedActivitiesDataSource>(),
        ));
    gh.lazySingleton<_i17.AddEmojiUsecase>(
        () => _i17.AddEmojiUsecase(gh<_i15.ActivityRepository>()));
    gh.lazySingleton<_i18.EditNameUsecase>(
        () => _i18.EditNameUsecase(gh<_i15.ActivityRepository>()));
    gh.lazySingleton<_i19.EditRecordsUsecase>(
        () => _i19.EditRecordsUsecase(gh<_i15.ActivityRepository>()));
    gh.lazySingleton<_i20.LoadActivitiesUsecase>(
        () => _i20.LoadActivitiesUsecase(gh<_i15.ActivityRepository>()));
    gh.lazySingleton<_i21.RecommendedActivitiesUsecase>(
        () => _i21.RecommendedActivitiesUsecase(gh<_i15.ActivityRepository>()));
    gh.lazySingleton<_i22.SwitchActivitiesUsecase>(
        () => _i22.SwitchActivitiesUsecase(gh<_i15.ActivityRepository>()));
    gh.factory<_i23.ActivitiesBloc>(() => _i23.ActivitiesBloc(
          loadActivitiesUsecase: gh<_i24.LoadActivitiesUsecase>(),
          switchActivityUsecase: gh<_i24.SwitchActivitiesUsecase>(),
          addEmojiUsecase: gh<_i24.AddEmojiUsecase>(),
          editNameUsecase: gh<_i24.EditNameUsecase>(),
          editRecordsUsecase: gh<_i24.EditRecordsUsecase>(),
        ));
    return this;
  }
}
