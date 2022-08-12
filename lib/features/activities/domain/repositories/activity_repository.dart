import 'package:dartz/dartz.dart';

import '../../../../core/error/return_types.dart';
import '../entities/activity.dart';

abstract class ActivityRepository {
  /// Loads [Activities] for the selected day
  Future<Either<Failure, List<Activity>>> getActivities(DateTime forTheDay);

  /// Saves the current [Activity] and returns a new one
  Future<Either<Failure, Activity>> switchActivities(String nextActivityName);

  /// Adds chosen emoji to a selected [Activity]
  Future<Either<Failure, Success>> addEmoji(Activity activity, String emoji);

  Future<Either<Failure, Success>> editName(Activity activity, String name);

  /// Inserts new activity and returns it entity
  Future<Either<Failure, Activity>> insertActivity({
    required String name,
    required DateTime startTime,
    DateTime endTime,
  });
}
