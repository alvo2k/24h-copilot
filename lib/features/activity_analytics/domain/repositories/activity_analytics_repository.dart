import '../../../activities/domain/entities/activity.dart';

abstract class ActivityAnalyticsRepository {
  Future<Stream<List<Activity>>> activityRecordsRange({
    required DateTime from,
    required DateTime to,
    String? name,
  });
}
