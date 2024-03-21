// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:copilot/core/common/data/datasources/activity_database.dart'
    as _i4;
import 'package:copilot/core/common/data/datasources/activity_local_data_source.dart'
    as _i10;
import 'package:copilot/core/notification_controller.dart' as _i3;
import 'package:copilot/features/activities/data/repositories/activity_repository_impl.dart'
    as _i9;
import 'package:copilot/features/activities/domain/repositories/activity_repository.dart'
    as _i8;
import 'package:copilot/features/activities/domain/usecases/activities_usecases.dart'
    as _i26;
import 'package:copilot/features/activities/domain/usecases/add_emoji_usecase.dart'
    as _i19;
import 'package:copilot/features/activities/domain/usecases/edit_name_usecase.dart'
    as _i20;
import 'package:copilot/features/activities/domain/usecases/edit_records_usecase.dart'
    as _i21;
import 'package:copilot/features/activities/domain/usecases/load_activities_usecase.dart'
    as _i22;
import 'package:copilot/features/activities/domain/usecases/recommended_activities_usecase.dart'
    as _i23;
import 'package:copilot/features/activities/domain/usecases/switch_activities_usecase.dart'
    as _i24;
import 'package:copilot/features/activities/presentation/bloc/activities_bloc.dart'
    as _i25;
import 'package:copilot/features/activity_analytics/data/datasources/activity_analytics_data_source.dart'
    as _i7;
import 'package:copilot/features/activity_analytics/data/repositories/activity_analytics_repository_impl.dart'
    as _i6;
import 'package:copilot/features/activity_analytics/domain/repositories/activity_analytics_repository.dart'
    as _i5;
import 'package:copilot/features/activity_analytics/domain/usecases/activity_analytics_usecase.dart'
    as _i12;
import 'package:copilot/features/backup/data/datasources/backup_data_source.dart'
    as _i13;
import 'package:copilot/features/backup/data/repositories/backup_repository_impl.dart'
    as _i28;
import 'package:copilot/features/backup/domain/repositories/backup_repository.dart'
    as _i27;
import 'package:copilot/features/backup/domain/usecases/export_usecase.dart'
    as _i31;
import 'package:copilot/features/backup/domain/usecases/import_usecase.dart'
    as _i32;
import 'package:copilot/features/card-editor/data/datasources/activity_settings_datasource.dart'
    as _i11;
import 'package:copilot/features/card-editor/data/repositories/activity_settings_repository_impl.dart'
    as _i18;
import 'package:copilot/features/card-editor/domain/repositories/activity_settings_repository.dart'
    as _i17;
import 'package:copilot/features/card-editor/domain/usecases/load_activities_settings_usecase.dart'
    as _i29;
import 'package:copilot/features/card-editor/domain/usecases/update_activity_settings_usecase.dart'
    as _i30;
import 'package:copilot/features/history/data/repositories/pie_chart_data_repository_impl.dart'
    as _i15;
import 'package:copilot/features/history/domain/repositories/pie_chart_data_repositoty.dart'
    as _i14;
import 'package:copilot/features/history/domain/usecases/pie_chart_data_usecase.dart'
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
    gh.singleton<_i3.NotificationController>(
        () => _i3.NotificationController());
    gh.lazySingleton<_i4.ActivityDatabase>(() => _i4.ActivityDatabase());
    gh.lazySingleton<_i5.ActivityAnalyticsRepository>(() =>
        _i6.ActivityAnalyticsRepositoryImpl(
            gh<_i7.ActivityAnalyticsDataSource>()));
    gh.lazySingleton<_i8.ActivityRepository>(
        () => _i9.ActivityRepositoryImpl(gh<_i10.ActivityLocalDataSource>()));
    gh.lazySingleton<_i11.ActivitySettingsDataSource>(
        () => _i11.ActivitySettingsDataSourceImpl(gh<_i4.ActivityDatabase>()));
    gh.lazySingleton<_i12.ActivityAnalyticsUseCase>(() =>
        _i12.ActivityAnalyticsUseCase(gh<_i5.ActivityAnalyticsRepository>()));
    gh.lazySingleton<_i13.BackupDataSource>(
        () => _i13.BackupDataSourceImpl(gh<_i4.ActivityDatabase>()));
    gh.lazySingleton<_i14.PieChartDataRepository>(() =>
        _i15.PieChartDataRepositoryImpl(gh<_i10.ActivityLocalDataSource>()));
    gh.lazySingleton<_i16.PieChartDataUsecase>(
        () => _i16.PieChartDataUsecase(gh<_i14.PieChartDataRepository>()));
    gh.lazySingleton<_i17.ActivitySettingsRepository>(() =>
        _i18.ActivitySettingsRepositoryImpl(
            gh<_i11.ActivitySettingsDataSource>()));
    gh.lazySingleton<_i19.AddEmojiUsecase>(
        () => _i19.AddEmojiUsecase(gh<_i8.ActivityRepository>()));
    gh.lazySingleton<_i20.EditNameUsecase>(
        () => _i20.EditNameUsecase(gh<_i8.ActivityRepository>()));
    gh.lazySingleton<_i21.EditRecordsUsecase>(
        () => _i21.EditRecordsUsecase(gh<_i8.ActivityRepository>()));
    gh.lazySingleton<_i22.LoadActivitiesUsecase>(
        () => _i22.LoadActivitiesUsecase(gh<_i8.ActivityRepository>()));
    gh.lazySingleton<_i23.RecommendedActivitiesUsecase>(
        () => _i23.RecommendedActivitiesUsecase(gh<_i8.ActivityRepository>()));
    gh.lazySingleton<_i24.SwitchActivitiesUsecase>(
        () => _i24.SwitchActivitiesUsecase(gh<_i8.ActivityRepository>()));
    gh.factory<_i25.ActivitiesBloc>(() => _i25.ActivitiesBloc(
          loadActivitiesUsecase: gh<_i26.LoadActivitiesUsecase>(),
          switchActivityUsecase: gh<_i26.SwitchActivitiesUsecase>(),
          addEmojiUsecase: gh<_i26.AddEmojiUsecase>(),
          editNameUsecase: gh<_i26.EditNameUsecase>(),
          editRecordsUsecase: gh<_i26.EditRecordsUsecase>(),
          recommendedActivitiesUsecase: gh<_i23.RecommendedActivitiesUsecase>(),
        ));
    gh.lazySingleton<_i27.BackupRepository>(
        () => _i28.BackupRepositoryImpl(gh<_i13.BackupDataSource>()));
    gh.lazySingleton<_i29.LoadActivitiesSettingsUsecase>(() =>
        _i29.LoadActivitiesSettingsUsecase(
            gh<_i17.ActivitySettingsRepository>()));
    gh.lazySingleton<_i30.UpdateActivitySettingsUsecase>(() =>
        _i30.UpdateActivitySettingsUsecase(
            gh<_i17.ActivitySettingsRepository>()));
    gh.lazySingleton<_i31.ExportUseCase>(
        () => _i31.ExportUseCase(gh<_i27.BackupRepository>()));
    gh.lazySingleton<_i32.ImportUseCase>(
        () => _i32.ImportUseCase(gh<_i27.BackupRepository>()));
    return this;
  }
}
