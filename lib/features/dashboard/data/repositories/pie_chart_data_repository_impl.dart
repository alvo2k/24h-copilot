import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/common/data/datasources/activity_local_data_source.dart';
import '../../../../core/common/data/models/activity_model.dart';
import '../../../../core/error/return_types.dart';
import '../../domain/repositories/pie_chart_data_repositoty.dart';

@LazySingleton(as: PieChartDataRepository)
class PieChartDataRepositoryImpl extends PieChartDataRepository {
  PieChartDataRepositoryImpl(this.localDataBase);

  final ActivityLocalDataSource localDataBase;

  @override
  Future<Stream<Either<Failure, List<ActivityModel>>>> getActivities({
    required int from,
    required int to,
    String? search,
  }) async {
    final rowsStream = await () async {
      // TODO search for names
      if (search != null && search.startsWith('#')) {
        return localDataBase.getRecordsRangeWithTag(
          from: from,
          to: to,
          tag: search.substring(1),
        );
      }
      return localDataBase.getRecordsRange(
        from: from,
        to: to,
      );
    }();

    return rowsStream.map<Either<Failure, List<ActivityModel>>>((rows) {
      List<ActivityModel> records = [];
      for (int i = 0; i < rows.length; i++) {
        final activityRow = rows[i];
        try {
          final activity = ActivityModel.fromDriftRow(
              activityRow, rows[i + 1].record.startTime);
          records.add(activity);
        } on RangeError catch (_) {
          // endTime = null
          final activity = ActivityModel.fromDriftRow(activityRow);
          records.add(activity);
        }
      }
      if (records.isEmpty) {
        return const Left(CacheFailure({'message': 'No records found'}));
      }
      return Right(records);
    });
  }

  @override
  Future<DateTime?> getFirstRecord() async {
    final record = await localDataBase.getFirstRecord();
    if (record != null) {
      return DateTime.fromMillisecondsSinceEpoch(record.startTime);
    }
    return null;
  }

  @override
  Future<Either<Failure, List<String>>> getSuggestion(String search) async {
    if (search.startsWith('#')) {
      return Right(await localDataBase.searchTags(search.substring(1)));
    } else {
      return Right(await localDataBase.searchActivities(search) ?? []);
    }
  }
}
