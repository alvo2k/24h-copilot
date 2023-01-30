import 'dart:ui';

import '../../../../core/error/exceptions.dart';
import '../models/activity_model.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/return_types.dart';
import '../../domain/entities/activity.dart';
import '../../domain/repositories/activity_repository.dart';
import '../datasources/data_sources_contracts.dart';
import '../datasources/drift/drift_db.dart';

@LazySingleton(as: ActivityRepository)
class ActivityRepositoryImpl implements ActivityRepository {
  ActivityRepositoryImpl({required this.localDataSource});

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
  Future<Either<Failure, Activity>> insertActivity({
    required String name,
    required DateTime startTime,
    required Color color,
    DateTime? endTime,
  }) async {
    try {
      final activitySettings =
          await localDataSource.findActivitySettings(name) ??
              await localDataSource.createActivity(name, color.value);

      RecordWithActivitySettings row;
      if (endTime != null) {
        row = await localDataSource.createRecord(
          activityName: activitySettings.name,
          startTime: startTime.millisecondsSinceEpoch,
          endTime: endTime.millisecondsSinceEpoch,
        );
      } else {
        row = await localDataSource.createRecord(
          activityName: activitySettings.name,
          startTime: startTime.millisecondsSinceEpoch,
        );
      }

      return Right(ActivityModel.fromDriftRow(row));
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
