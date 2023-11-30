import 'dart:ui';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/common/activity_settings.dart';
import '../../../../core/common/data/datasources/activity_local_data_source.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/return_types.dart';
import '../../domain/repositories/activity_settings_repository.dart';
import '../models/activity_settings_model.dart';

@LazySingleton(as: ActivitySettingsRepository)
class ActivitySettingsRepositoryImpl extends ActivitySettingsRepository {
  ActivitySettingsRepositoryImpl(this.localDataSource);

  final ActivityLocalDataSource localDataSource;

  @override
  Future<Either<Failure, List<ActivitySettingsModel>>>
      loadActivitiesSettings() async {
    try {
      final rows = await localDataSource.getActivitiesSettings();
      final activities =
          rows.map((row) => ActivitySettingsModel.fromDriftRow(row)).toList();

      return Right(activities);
    } on CacheException catch (_) {
      return Left(Failure(type: FailureType.localStorage));
    }
  }

  @override
  Future<Either<Failure, ActivitySettings>> updateActivitySettings({
    required String activityName,
    required String newActivityName,
    required Color newColor,
    List<String>? tags,
    int? newGoal,
  }) async {
    try {
      final inLineTags = () {
        if (tags == null || tags.isEmpty) {
          return null;
        } else {
          return tags.join(';');
        }
      }();
      final row = await localDataSource.updateActivitySettings(
        activityName: activityName,
        newActivityName: newActivityName,
        newColorHex: newColor.value,
        tags: inLineTags,
        newGoal: newGoal,
      );

      return Right(ActivitySettingsModel.fromDriftRow(row));
    } on CacheException catch (_) {
      return Left(Failure(type: FailureType.localStorage));
    }
  }
}
