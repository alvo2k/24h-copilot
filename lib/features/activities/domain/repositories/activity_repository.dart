import 'dart:ui';

import 'package:dartz/dartz.dart';

import '../../../../core/error/return_types.dart';
import '../entities/activity.dart';

abstract class ActivityRepository {
  /// Loads [Activities] for the selected day
  Future<Either<Failure, List<Activity>>> getActivities(DateTime forTheDay);

  /// Saves the current [Activity] and returns a new one
  Future<Either<Failure, Activity>> switchActivities(
    String nextActivityName,
    DateTime startTime, [
    Color color,
  ]);

  /// Adds chosen emoji to a selected [Activity]
  Future<Either<Failure, Success>> addEmoji(int recordId, String emoji);

  /// Changes the name of individual [Activity], returns a new one with
  /// new [ActivitySettings] or cached
  Future<Either<Failure, Activity>> editName({
    required int recordId,
    required String newName,
    Color? color,
    });

  /// Inserts new activity and returns it entity
  Future<Either<Failure, Activity>> insertActivity({
    required String name,
    required DateTime startTime,
    DateTime endTime,
    Color color,
  });

  Future<Either<Failure, bool>> hasActivitySettings(String activityName);
}
