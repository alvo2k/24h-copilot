import 'package:copilot/core/error/exceptions.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/common/data/datasources/data_sources_contracts.dart';
import '../../../../core/common/data/models/activity_model.dart';
import '../../../../core/error/return_types.dart';
import '../../domain/repositories/pie_chart_data_repositoty.dart';

@LazySingleton(as: PieChartDataRepository)
class PieChartDataRepositoryImpl extends PieChartDataRepository {
  PieChartDataRepositoryImpl(this.localDataBase);

  final ActivityLocalDataSource localDataBase;

  @override
  Future<Either<Failure, List<ActivityModel>>> getActivities(
      DateTime from, DateTime to) async {
    try {
      final rows = await localDataBase.getRecordsRange(
        from: from.toUtc().millisecondsSinceEpoch,
        to: to.toUtc().millisecondsSinceEpoch,
      );

      List<ActivityModel> records = [];
      for (int i = 0; i < rows.length; i++) {
        final activityRow = rows[i];
        try {
          final activity = ActivityModel.fromDriftRow(
              activityRow, rows[i + 1].record.startTime);
          records.add(activity);
        } on RangeError catch (_) {
          final activity = ActivityModel.fromDriftRow(
              activityRow, to.millisecondsSinceEpoch);
          records.add(activity);
        }
      }
      if (records.isEmpty) {
        return const Left(CacheFailure({'message': 'No records found'}));
      }
      return Right(records);
    } on CacheException catch (_) {
      return const Left(CacheFailure({'message': 'Cache failure'}));
    }
  }
}
