import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/common/data/datasources/drift_db.dart';
import '../../../../core/common/data/models/activity_model.dart';
import '../../../../core/error/return_types.dart';
import '../../domain/repositories/pie_chart_data_repositoty.dart';

@LazySingleton(as: PieChartDataRepository)
class PieChartDataRepositoryImpl extends PieChartDataRepository {
  PieChartDataRepositoryImpl(this.localDataBase);

  final ActivityDatabase localDataBase;

  @override
  Future<Either<Failure, List<ActivityModel>>> getActivities(
      DateTime from, DateTime to) async {
    final recordsFromDb = await localDataBase.getRecords(
      from: from.toUtc().millisecondsSinceEpoch,
      to: to.toUtc().millisecondsSinceEpoch,
    );

    List<ActivityModel> records = [];
    for (final record in recordsFromDb) {
      records.add(ActivityModel.fromDriftRow(record));
    }
    if (records.isEmpty) {
      return const Left(CacheFailure({'message': 'No records found'}));
    }
    return Right(records);
  }
}
