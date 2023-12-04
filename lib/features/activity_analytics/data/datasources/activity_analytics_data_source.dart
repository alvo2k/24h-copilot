import '../../../../core/common/data/datasources/activity_database.dart';

abstract interface class ActivityAnalyticsDataSource {
  Future<Stream<List<RecordWithActivitySettings>>> getRecordsRange({
    required int from,
    required int to,
    String? name,
  });
}
