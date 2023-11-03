import 'dart:ui';

import 'package:dartz/dartz.dart';

import '../../../../core/common/activity_settings.dart';
import '../../../../core/error/return_types.dart';
import '../entities/activity.dart';
import '../entities/edit_record.dart';

abstract class ActivityRepository {
  /// Loads [Activities] in the range
  Future<Stream<List<Activity>>> getActivities({
    required int from,
    required int to,
  });

  /// Saves the current [Activity] and returns a new one
  Future<Either<Failure, Activity>> switchActivities({
    required String nextActivityName,
    required DateTime startTime,
    required Color color,
  });

  /// Adds chosen emoji to a selected [Activity]
  Future<Either<Failure, Success>> addEmoji(int recordId, String emoji);

  /// Changes the name of individual [Activity], returns a new one with
  /// new [ActivitySettings] or cached
  Future<Either<Failure, Activity>> editName({
    required int recordId,
    required String newName,
    required Color color,
  });

  /// Edits records table and returns it entity
  Future<Either<Failure, Activity>> editRecords(EditRecord record);

  Future<Either<Failure, bool>> hasActivitySettings(String activityName);

  Future<List<ActivitySettings>> mostCommonActivities({
    required int ammount,
  });

  Stream<ActivitySettings?> listenToCommonActivities();

  Future<void> countActivity(String activityName);
}
