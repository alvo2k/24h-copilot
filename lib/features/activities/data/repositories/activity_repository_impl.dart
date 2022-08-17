import 'dart:ui';

import 'package:copilot/core/error/exceptions.dart';
import 'package:copilot/features/activities/data/models/activity_model.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/return_types.dart';
import '../../domain/entities/activity.dart';
import '../../domain/repositories/activity_repository.dart';
import '../datasources/activity_local_data_source.dart';

@LazySingleton(as: ActivityRepository)
class ActivityRepositoryImpl implements ActivityRepository {
  ActivityRepositoryImpl({required this.localDataSource});

  final ActivityLocalDataSource localDataSource;

  @override
  Future<Either<Failure, Success>> addEmoji(
    int recordId,
    String emoji,
  ) {
    // TODO: implement addEmoji
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Activity>> editName({
    required int recordId,
    required String newName,
    Color? color,
  }) async {
    try {
      if (color != null) {
        localDataSource.createActivity(newName, color.value);
      }
      final activitySettings =
          await localDataSource.findActivitySettings(newName);
      if (activitySettings == null) {
        return const Left(CacheFailure());
      }
      final id = activitySettings[ActivityModel.colIdActivity] as int;
      final activityJson = await localDataSource.updateRecordSettings(
          idRecord: recordId, idActivity: id);
      return Right(ActivityModel.fromJson(activityJson));
    } on CacheException {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<ActivityModel>>> getActivities(
      DateTime forTheDay) async {
    assert(forTheDay.isUtc, true);

    final from = forTheDay.millisecondsSinceEpoch;
    final to = forTheDay
        .add(const Duration(
            hours: 23, minutes: 59, seconds: 59, milliseconds: 999))
        .millisecondsSinceEpoch;

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
    DateTime? endTime,
    Color? color,
  }) {
    // TODO: implement insertActivity
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Activity>> switchActivities(
    String nextActivityName,
    DateTime startTime, [
    Color? color,
  ]) async {
    try {
      if (color != null) {
        localDataSource.createActivity(nextActivityName, color.value);
      }
      final activitySettings =
          await localDataSource.findActivitySettings(nextActivityName);
      if (activitySettings == null) {
        return const Left(CacheFailure());
      }
      final id = activitySettings[ActivityModel.colIdActivity] as int;
      final activityJson = await localDataSource.createRecord(
        idActivity: id,
        startTime: startTime,
      );
      return Right(ActivityModel.fromJson(activityJson));
    } on CacheException {
      return const Left(CacheFailure());
    }
  }

  Future<List<ActivityModel>> _getActititiesFromDataSource(
      int from, int to) async {
    return await localDataSource
        .getActivities(from: from, to: to)
        .then((value) => value.map((e) => ActivityModel.fromJson(e)).toList());
  }
}
