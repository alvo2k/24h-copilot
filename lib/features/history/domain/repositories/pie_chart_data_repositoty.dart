import 'package:dartz/dartz.dart';

import '../../../../core/common/activity_settings.dart';
import '../../../../core/common/data/models/activity_model.dart';
import '../../../../core/error/return_types.dart';

abstract class PieChartDataRepository {
  Future<Stream<Either<Failure, List<ActivityModel>>>> getActivities({
    required int from,
    required int to,
    String? search,
  });

  Future<List<ActivitySettings>> searchActivities(String search);

  Future<List<String>> searchTags(String search);

  Future<DateTime?> getFirstEverRecordStartTime();
}
