import 'package:dartz/dartz.dart';

import '../../../../core/common/data/models/activity_model.dart';
import '../../../../core/error/return_types.dart';

abstract class PieChartDataRepository {
  Future<Either<Failure, List<ActivityModel>>> getActivities({
    required DateTime from,
    required DateTime to,
    String? search,
  });

  Future<Either<Failure, List<String>>> getSuggestion(String search);

  Future<DateTime?> getFirstRecord();
}
