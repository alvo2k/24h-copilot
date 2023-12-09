import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/return_types.dart';
import '../entities/entities.dart';
import '../repositories/activity_analytics_repository.dart';

@LazySingleton()
class ActivityAnalyticsUseCase {
  ActivityAnalyticsUseCase(this._repository);

  final ActivityAnalyticsRepository _repository;

  Future<Either<Failure, HeatMapData>> call(String activityName) async {
    final recordsStream = await _repository.activityRecordsRange(
      from: DateTime.now().subtract(const Duration(days: 365)),
      to: DateTime.now(),
      name: activityName,
    );
    final data = await recordsStream.first;

    if (data.isEmpty) {
      return left(Failure(type: FailureType.localStorage));
    }

    if (!data.first.goalSet) {
      return right(HeatMapData(data[0], const {}));
    }

    Map<DateTime, int> dataset = {};
    for (final record in data) {
      if (record.goalSet) {
        final date = DateUtils.dateOnly(record.endTime ?? DateTime.now());
        dataset.containsKey(date)
            ? dataset.update(
                date,
                (v) => min(100, v += (record.goalCompletion * 100).toInt()),
              )
            : dataset[date] = (record.goalCompletion * 100).toInt();
      }
    }

    return right(HeatMapData(data[0], dataset));
  }
}
