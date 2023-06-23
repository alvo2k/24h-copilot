import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../entities/activity_day.dart';
import '../repositories/activity_repository.dart';

@LazySingleton()
class LoadActivitiesUsecase {
  LoadActivitiesUsecase(this.repository);
 
  final ActivityRepository repository;

  Future<Stream<ActivityDay>> call(
    LoadActivitiesParams params,
  ) async {
    assert(DateUtils.dateOnly(params.forTheDay) == params.forTheDay);

    final from = params.forTheDay.toUtc().millisecondsSinceEpoch;
    final to = params.forTheDay
        .add(const Duration(days: 1))
        .toUtc()
        .millisecondsSinceEpoch;

    final stream = await repository.getActivities(from: from, to: to);

    return stream.map<ActivityDay>(
      (result) => ActivityDay(result, DateUtils.dateOnly(params.forTheDay)),
    );
  }
}

class LoadActivitiesParams {
  const LoadActivitiesParams(this.forTheDay);

  final DateTime forTheDay;
}
