import 'package:injectable/injectable.dart';

import '../../../../core/common/data/models/activity_model.dart';
import '../../../activities/domain/entities/activity.dart';
import '../../domain/repositories/activity_analytics_repository.dart';
import '../datasources/activity_analytics_data_source.dart';

@LazySingleton(as: ActivityAnalyticsRepository)
class ActivityAnalyticsRepositoryImpl implements ActivityAnalyticsRepository {
  ActivityAnalyticsRepositoryImpl(this._dataSource);

  final ActivityAnalyticsDataSource _dataSource;

  @override
  Future<Stream<List<Activity>>> activityRecordsRange({
    required DateTime from,
    required DateTime to,
    String? name,
  }) async {
    final recordsStream = await _dataSource.getRecordsRange(
      from: from.toUtc().millisecondsSinceEpoch,
      to: to.toUtc().millisecondsSinceEpoch,
      name: name,
    );

    return recordsStream.asyncMap((rows) async {
      List<ActivityModel> records = [];
      for (int i = 0; i < rows.length; i++) {
        final activityRow = rows[i];
        final activity = ActivityModel.fromDriftRow(
          activityRow,
          await _dataSource.findEndTimeFor(activityRow.record.startTime),
        );
        records.add(activity);
      }
      return records;
    });
  }
}
