import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/common/data/datasources/activity_local_data_source.dart';
import '../../../../core/common/data/models/activity_model.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/return_types.dart';
import '../../domain/entities/activity.dart';
import '../../domain/entities/edit_record.dart';
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
  Future<Either<Failure, Activity>> editRecords(EditRecord editData) async {
    try {
      await localDataSource.findActivitySettings(editData.activityName) ??
          await localDataSource.createActivity(
              editData.activityName, editData.color.value);

      switch (editData.mode) {
        case EditMode.switchWithStartTime:
          {
            final row = await localDataSource.createRecord(
                activityName: editData.activityName,
                startTime: editData.startTime!.millisecondsSinceEpoch);
            return Right(ActivityModel.fromDriftRow(row));
          }
        case EditMode.override:
          {
            final row = await localDataSource.updateRecordSettings(
                idRecord: editData.toChange!.recordId,
                activityName: editData.activityName);
            if (editData.toChange!.endTime != null) {
              return Right(ActivityModel.fromDriftRow(row)
                  .changeEndTime(editData.toChange!.endTime!));
            } else {
              return Right(ActivityModel.fromDriftRow(row));
            }
          }
        case EditMode.placeInside:
          {
            final row = await localDataSource.createRecord(
              activityName: editData.activityName,
              startTime: editData.startTime!.millisecondsSinceEpoch,
            );
            await localDataSource.createRecord(
              activityName: editData.toChange!.name,
              startTime: editData.endTime!.millisecondsSinceEpoch,
            );
            return Right(ActivityModel.fromDriftRow(row)
                .changeEndTime(editData.endTime!));
          }
        case EditMode.placeAbove:
          {
            final row = await localDataSource.createRecord(
              activityName: editData.activityName,
              startTime: editData.toChange!.startTime.millisecondsSinceEpoch,
            );
            await localDataSource.updateRecordTime(
              idRecord: editData.toChange!.recordId,
              startTime: editData.endTime!.millisecondsSinceEpoch,
            );
            return Right(ActivityModel.fromDriftRow(row)
                .changeEndTime(editData.endTime!));
          }
        case EditMode.placeBellow:
          {
            final row = await localDataSource.createRecord(
              activityName: editData.activityName,
              startTime: editData.startTime!.millisecondsSinceEpoch,
            );
            return Right(ActivityModel.fromDriftRow(row)
                .changeEndTime(editData.toChange!.endTime!));
          }
        default:
          return const Left(CacheFailure({'message': 'unknown edit mode'}));
      }
    } on CacheException {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Stream<List<Activity>>> getActivities({
    required int from,
    required int to,
  }) async {
    final rowsStream = await localDataSource.getRecordsRange(
      from: from,
      to: to,
    );

    // add endTime (startTime of the next row)
    return rowsStream.map<List<ActivityModel>>((rows) {
      List<ActivityModel> records = [];
      for (int i = 0; i < rows.length; i++) {
        final activityRow = rows[i];
        try {
          final activity = ActivityModel.fromDriftRow(
              activityRow, rows[i + 1].record.startTime);
          records.add(activity);
        } on RangeError catch (_) {
          // last activity, endTime = null
          final activity = ActivityModel.fromDriftRow(activityRow);
          records.add(activity);
        }
      }
      return records;
    });
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
