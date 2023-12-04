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
  }) async =>
      (await _dataSource.getRecordsRange(
        from: from.toUtc().millisecondsSinceEpoch,
        to: to.toUtc().millisecondsSinceEpoch,
        name: name,
      ))
          .map(
        (event) => event
            .map(
              (e) => ActivityModel.fromDriftRow(e),
            )
            .toList(),
      );
}
