import '../../../../core/common/data/datasources/activity_database.dart';
import '../../../../core/common/data/datasources/activity_local_data_source.dart';

abstract interface class ActivityAnalyticsDataSource with ActivityFindEndTime{
  Future<Stream<List<RecordWithActivitySettings>>> getRecordsRange({
    required int from,
    required int to,
    String? name,
  });
}
