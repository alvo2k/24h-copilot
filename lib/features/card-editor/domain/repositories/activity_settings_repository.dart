import 'dart:ui';

import 'package:dartz/dartz.dart';

import '../../../../core/common/activity_settings.dart';
import '../../../../core/error/return_types.dart';

abstract class ActivitySettingsRepository {
  /// This will load all existing [ActivitySettings]
  Future<Either<Failure, List<ActivitySettings>>> loadActivitiesSettings();

  Future<Either<Failure, ActivitySettings>> updateActivitySettings({
    required String activityName,
    String? newActivityName,
    Color? newColor,
    List<String>? tags,
    int? newGoal,
  });
}
