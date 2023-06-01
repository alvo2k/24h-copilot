import 'package:dartz/dartz.dart';

import '../../../../core/common/data/models/activity_model.dart';
import '../../../../core/error/return_types.dart';

abstract class PieChartDataRepository {
  Future<Stream<Either<Failure, List<ActivityModel>>>> getActivities({
    required int from,
    required int to,
    String? search,
  });

  Future<Either<Failure, List<String>>> getSuggestion(String search);

  Future<DateTime?> getFirstRecord();
}
