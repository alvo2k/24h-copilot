// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:copilot/core/common/data/datasources/drift_db.dart' as _i3;
import 'package:copilot/features/activities/data/repositories/activity_repository_impl.dart'
    as _i5;
import 'package:copilot/features/activities/domain/repositories/activity_repository.dart'
    as _i4;
import 'package:copilot/features/activities/domain/usecases/activities_usecases.dart'
    as _i17;
import 'package:copilot/features/activities/domain/usecases/add_emoji_usecase.dart'
    as _i6;
import 'package:copilot/features/activities/domain/usecases/edit_name_usecase.dart'
    as _i7;
import 'package:copilot/features/activities/domain/usecases/edit_records_usecase.dart'
    as _i8;
import 'package:copilot/features/activities/domain/usecases/load_activities_usecase.dart'
    as _i11;
import 'package:copilot/features/activities/domain/usecases/switch_activities_usecase.dart'
    as _i15;
import 'package:copilot/features/activities/presentation/bloc/activities_bloc.dart'
    as _i16;
import 'package:copilot/features/dashboard/data/repositories/pie_chart_data_repository_impl.dart'
    as _i13;
import 'package:copilot/features/dashboard/domain/repositories/pie_chart_data_repositoty.dart'
    as _i12;
import 'package:copilot/features/dashboard/domain/usecases/pie_chart_data_usecase.dart'
    as _i14;
import 'package:copilot/features/firebase/data/repositories/firebase_auth_repository_impl.dart'
    as _i10;
import 'package:copilot/features/firebase/domain/repositories/firebase_auth_repository.dart'
    as _i9;
import 'package:copilot/features/firebase/domain/usecases/auth_usecase.dart'
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
    gh.lazySingleton<_i3.ActivityDatabase>(() => _i3.ActivityDatabase());
    gh.lazySingleton<_i4.ActivityRepository>(
        () => _i5.ActivityRepositoryImpl(gh<_i3.ActivityDatabase>()));
    gh.lazySingleton<_i6.AddEmojiUsecase>(
        () => _i6.AddEmojiUsecase(gh<_i4.ActivityRepository>()));
    gh.lazySingleton<_i7.EditNameUsecase>(
        () => _i7.EditNameUsecase(gh<_i4.ActivityRepository>()));
    gh.lazySingleton<_i8.EditRecordsUsecase>(
        () => _i8.EditRecordsUsecase(gh<_i4.ActivityRepository>()));
    gh.lazySingleton<_i9.FirebaseAuthRepository>(
        () => _i10.FirebaseAuthRepositoryImpl());
    gh.lazySingleton<_i11.LoadActivitiesUsecase>(
        () => _i11.LoadActivitiesUsecase(gh<_i4.ActivityRepository>()));
    gh.lazySingleton<_i12.PieChartDataRepository>(
        () => _i13.PieChartDataRepositoryImpl(gh<_i3.ActivityDatabase>()));
    gh.lazySingleton<_i14.PieChartDataUsecase>(
        () => _i14.PieChartDataUsecase(gh<_i12.PieChartDataRepository>()));
    gh.lazySingleton<_i15.SwitchActivitiesUsecase>(
        () => _i15.SwitchActivitiesUsecase(gh<_i4.ActivityRepository>()));
    gh.factory<_i16.ActivitiesBloc>(() => _i16.ActivitiesBloc(
          loadActivitiesUsecase: gh<_i17.LoadActivitiesUsecase>(),
          switchActivityUsecase: gh<_i17.SwitchActivitiesUsecase>(),
          addEmojiUsecase: gh<_i17.AddEmojiUsecase>(),
          editNameUsecase: gh<_i17.EditNameUsecase>(),
          editRecordsUsecase: gh<_i17.EditRecordsUsecase>(),
        ));
    gh.lazySingleton<_i18.AuthUsecase>(
        () => _i18.AuthUsecase(gh<_i9.FirebaseAuthRepository>()));
    return this;
  }
}
