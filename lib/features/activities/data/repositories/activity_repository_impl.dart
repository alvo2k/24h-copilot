import 'dart:ui';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/common/data/datasources/drift_db.dart';
import '../../../../core/common/data/models/activity_model.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/return_types.dart';
import '../../domain/entities/activity.dart';
import '../../domain/repositories/activity_repository.dart';

@LazySingleton(as: ActivityRepository)
class ActivityRepositoryImpl implements ActivityRepository {
  ActivityRepositoryImpl(this.localDataSource);

  final ActivityDatabase localDataSource;

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
  Future<Either<Failure, Activity>> editRecords(
      {required String name,
      DateTime? startTime,
      required Color color,
      DateTime? endTime,
      Activity? toChange}) async {
    try {
      final activitySettings =
          await localDataSource.findActivitySettings(name) ??
              await localDataSource.createActivity(name, color.value);

      if (toChange == null) {
        // switch activity with start time change
        assert(startTime != null);
        await localDataSource.updateRecordTime(
          idRecord: await localDataSource.getLastRecordId(),
          endTime: startTime!.millisecondsSinceEpoch,
        );
        final row = await localDataSource.createRecord(
            activityName: name, startTime: startTime.millisecondsSinceEpoch);
        return Right(ActivityModel.fromDriftRow(row));
      }

      if (startTime == null && endTime == null) {
        // overwrite record
        final row = await localDataSource.updateRecordSettings(
            idRecord: toChange.recordId, activityName: name);
        return Right(ActivityModel.fromDriftRow(row));
      }

      if (startTime != null && endTime == null) {
        if (toChange.endTime == null) {
          // overwrite record
          final row = await localDataSource.updateRecordSettings(
              idRecord: toChange.recordId, activityName: name);
          return Right(ActivityModel.fromDriftRow(row));
        }
        // toChange.endTime == startTime; startTime -- endTime
        await localDataSource.updateRecordTime(
          idRecord: toChange.recordId,
          endTime: startTime.millisecondsSinceEpoch,
        );
        final row = await localDataSource.createRecord(
          activityName: name,
          startTime: startTime.millisecondsSinceEpoch,
          endTime: toChange.endTime!.millisecondsSinceEpoch,
        );
        return Right(ActivityModel.fromDriftRow(row));
      }
      if (startTime == null && endTime != null) {
        // assert(toChange.endTime != null);
        // toChange.startTime == endTime; startTime -- endTime
        await localDataSource.updateRecordTime(
          idRecord: toChange.recordId,
          startTime: endTime.millisecondsSinceEpoch,
        );
        final row = await localDataSource.createRecord(
          activityName: name,
          startTime: toChange.startTime.millisecondsSinceEpoch,
          endTime: endTime.millisecondsSinceEpoch,
        );
        return Right(ActivityModel.fromDriftRow(row));
      }

      // insert in between
      await localDataSource.updateRecordTime(
        idRecord: toChange.recordId,
        endTime: startTime!.millisecondsSinceEpoch,
      );
      final row = await localDataSource.createRecord(
        activityName: name,
        startTime: startTime.millisecondsSinceEpoch,
        endTime: endTime!.millisecondsSinceEpoch,
      );
      await localDataSource.createRecord(
        activityName: toChange.name,
        startTime: endTime.millisecondsSinceEpoch,
        endTime: toChange.endTime != null
            ? toChange.endTime!.millisecondsSinceEpoch
            : null,
      );
      return Right(ActivityModel.fromDriftRow(row));
    } on CacheException {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<ActivityModel>>> getActivities(
      DateTime forTheDay) async {
    assert(forTheDay.isUtc, true);

    final from = forTheDay.millisecondsSinceEpoch;
    final to = forTheDay.add(const Duration(days: 1)).millisecondsSinceEpoch;

    try {
      final activities = await _getActititiesFromDataSource(from, to);
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
      await localDataSource.updateRecordTime(
        idRecord: row.record.idRecord - 1,
        endTime: startTime.millisecondsSinceEpoch,
      );
      return Right(ActivityModel.fromDriftRow(row));
    } on CacheException {
      return const Left(CacheFailure());
    }
  }

  Future<List<ActivityModel>> _getActititiesFromDataSource(
      int from, int to) async {
    return await localDataSource.getRecords(from: from, to: to).then(
        (value) => value.map((e) => ActivityModel.fromDriftRow(e)).toList());
  }
}
