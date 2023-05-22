import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/return_types.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/activity.dart';
import '../entities/activity_day.dart';
import '../repositories/activity_repository.dart';

@LazySingleton()
class LoadActivitiesUsecase extends UseCase<ActivityDay, LoadActivitiesParams> {
  LoadActivitiesUsecase(this.repository);

  final ActivityRepository repository;

  @override
  Future<Either<Failure, ActivityDay>> call(
    LoadActivitiesParams params,
  ) async {
    assert(DateUtils.dateOnly(params.forTheDay) == params.forTheDay);

    final from = params.forTheDay.toUtc().millisecondsSinceEpoch;
    final to = () {
      if (DateUtils.dateOnly(DateTime.now()) == params.forTheDay) {
        // if load today - load entire day
        return DateTime.now().toUtc().millisecondsSinceEpoch;
      }
      return params.forTheDay
          .add(const Duration(days: 1))
          .toUtc()
          .millisecondsSinceEpoch;
    }();
    final result = await repository.getActivities(from: from, to: to);

    return result.fold(
      (l) => Left(l),
      (r) => Right(ActivityDay(r, DateUtils.dateOnly(params.forTheDay))),
    );
  }
}

class LoadActivitiesParams {
  const LoadActivitiesParams(this.forTheDay);

  final DateTime forTheDay;
}

extension TakesPlacesDates on Activity {
  List<DateTime> takesPlacesDates() {
    if (DateUtils.dateOnly((endTime ?? DateTime.now())
            .subtract(const Duration(milliseconds: 1))) ==
        DateUtils.dateOnly(startTime)) {
      return [DateUtils.dateOnly(startTime)];
    } else {
      final length = DateUtils.dateOnly(endTime ?? DateTime.now())
              .difference(DateUtils.dateOnly(startTime))
              .inDays +
          1;
      return List<DateTime>.generate(length,
          (index) => DateUtils.dateOnly(startTime.add(Duration(days: index))));
    }
  }
}
