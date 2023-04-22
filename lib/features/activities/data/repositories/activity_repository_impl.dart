import 'dart:ui';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/common/data/datasources/data_sources_contracts.dart';
import '../../../../core/common/data/models/activity_model.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/return_types.dart';
import '../../domain/entities/activity.dart';
import '../../domain/repositories/activity_repository.dart';

@LazySingleton(as: ActivityRepository)
class ActivityRepositoryImpl implements ActivityRepository {
  ActivityRepositoryImpl(this.localDataSource);

  final ActivityLocalDataSource localDataSource;

  @override
  Future<Either<Failure, Success>> addEmoji(
    int recordId,
    String emoji,
  ) async {
    try {
      await localDataSource.updateRecordEmoji(recordId, emoji);
      return const Right(Success());
    } on CacheException {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Activity>> editName({
    required int recordId,
    required String newName,
    required Color color,
  }) async {
    try {
      final activitySettings =
          await localDataSource.findActivitySettings(newName) ??
              await localDataSource.createActivity(newName, color.value);

      final row = await localDataSource.updateRecordSettings(
        idRecord: recordId,
        activityName: activitySettings.name,
      );
      return Right(ActivityModel.fromDriftRow(row));
    } on CacheException {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Activity>> editRecords({
    required String name,
    DateTime? startTime,
    required Color color,
    DateTime? endTime,
    Activity? toChange,
  }) async {
    try {
      await localDataSource.findActivitySettings(name) ??
          await localDataSource.createActivity(name, color.value);

      return const Left(CacheFailure({'message': 'edit records unavalable'}));

      //   if (toChange == null) {
      //     // switch activity with start time change
      //     assert(startTime != null);
      //     await localDataSource.updateRecordTime(
      //       idRecord: await localDataSource.getLastRecordId(),
      //       endTime: startTime!.millisecondsSinceEpoch,
      //     );
      //     final row = await localDataSource.createRecord(
      //         activityName: name, startTime: startTime.millisecondsSinceEpoch);
      //     return Right(ActivityModel.fromDriftRow(row));
      //   }

      //   if (startTime == null && endTime == null) {
      //     // overwrite record
      //     final row = await localDataSource.updateRecordSettings(
      //         idRecord: toChange.recordId, activityName: name);
      //     return Right(ActivityModel.fromDriftRow(row));
      //   }

      //   if (startTime != null && endTime == null) {
      //     if (toChange.endTime == null) {
      //       // overwrite record
      //       final row = await localDataSource.updateRecordSettings(
      //           idRecord: toChange.recordId, activityName: name);
      //       return Right(ActivityModel.fromDriftRow(row));
      //     }
      //     // toChange.endTime == startTime; startTime -- endTime
      //     await localDataSource.updateRecordTime(
      //       idRecord: toChange.recordId,
      //       endTime: startTime.millisecondsSinceEpoch,
      //     );
      //     final row = await localDataSource.createRecord(
      //       activityName: name,
      //       startTime: startTime.millisecondsSinceEpoch,
      //       endTime: toChange.endTime!.millisecondsSinceEpoch,
      //     );
      //     return Right(ActivityModel.fromDriftRow(row));
      //   }
      //   if (startTime == null && endTime != null) {
      //     // assert(toChange.endTime != null);
      //     // toChange.startTime == endTime; startTime -- endTime
      //     await localDataSource.updateRecordTime(
      //       idRecord: toChange.recordId,
      //       startTime: endTime.millisecondsSinceEpoch,
      //     );
      //     final row = await localDataSource.createRecord(
      //       activityName: name,
      //       startTime: toChange.startTime.millisecondsSinceEpoch,
      //       endTime: endTime.millisecondsSinceEpoch,
      //     );
      //     return Right(ActivityModel.fromDriftRow(row));
      //   }

      //   // insert in between
      //   await localDataSource.updateRecordTime(
      //     idRecord: toChange.recordId,
      //     endTime: startTime!.millisecondsSinceEpoch,
      //   );
      //   final row = await localDataSource.createRecord(
      //     activityName: name,
      //     startTime: startTime.millisecondsSinceEpoch,
      //     endTime: endTime!.millisecondsSinceEpoch,
      //   );
      //   await localDataSource.createRecord(
      //     activityName: toChange.name,
      //     startTime: endTime.millisecondsSinceEpoch,
      //     endTime: toChange.endTime != null
      //         ? toChange.endTime!.millisecondsSinceEpoch
      //         : null,
      //   );
      //   return Right(ActivityModel.fromDriftRow(row));
    } on CacheException {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<ActivityModel>>> getActivities(
      {required int ammount, int? skip}) async {
    try {
      final activities = await _getActititiesFromDataSource(ammount, skip);
      return Right(activities);
    } on CacheException {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> hasActivitySettings(String activityName) async {
    try {
      final result = await localDataSource.findActivitySettings(activityName);
      if (result == null) {
        return const Right(false);
      } else {
        return const Right(true);
      }
    } on CacheException {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Activity>> switchActivities({
    required String nextActivityName,
    required DateTime startTime,
    required Color color,
  }) async {
    try {
      final activitySettings = await localDataSource
              .findActivitySettings(nextActivityName) ??
          await localDataSource.createActivity(nextActivityName, color.value);

      final row = await localDataSource.createRecord(
        activityName: activitySettings.name,
        startTime: startTime.millisecondsSinceEpoch,
      );
      return Right(ActivityModel.fromDriftRow(row));
    } on CacheException {
      return const Left(CacheFailure());
    }
  }

  Future<List<ActivityModel>> _getActititiesFromDataSource(
      int ammount, int? skip) async {
    return await localDataSource
        .getRecords(ammount: ammount, skip: skip)
        .then((rows) {
      List<ActivityModel> outList = [];
      for (int i = 0; i < rows.length; i++) {
        final activityRow = rows[i];
        try {
          final activity = ActivityModel.fromDriftRow(
              activityRow, rows[i - 1].record.startTime);
          outList.add(activity);
        } on RangeError catch (_) {
          final activity = ActivityModel.fromDriftRow(activityRow);
          outList.add(activity);
        }
      }
      return outList;
    });
  }
}
