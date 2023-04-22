import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/return_types.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/activity.dart';
import '../entities/activity_day.dart';
import '../repositories/activity_repository.dart';

@LazySingleton()
class LoadActivitiesUsecase
    extends UseCase<List<ActivityDay>, LoadActivitiesParams> {
  LoadActivitiesUsecase(this.repository);

  final ActivityRepository repository;

  @override
  Future<Either<Failure, List<ActivityDay>>> call(
    LoadActivitiesParams params,
  ) async {
    final result = await repository.getActivities(
      ammount: params.ammount,
      skip: params.skip,
    );

    return result.fold((l) => Left(l), (r) {
      return Right(_splitActivitiesByDays(r));
    });
  }

  List<ActivityDay> _splitActivitiesByDays(List<Activity> list) {
    if (list.isEmpty) return [];

    final daysAmmount = DateUtils.dateOnly(list[0].endTime ?? DateTime.now())
            .difference(DateUtils.dateOnly(list.last.startTime))
            .inDays +
        1;
    final listDates = List<DateTime>.generate(
        daysAmmount,
        (index) => DateUtils.dateOnly(list[0].endTime ?? DateTime.now())
            .subtract(Duration(days: index)),
        growable: false);

    Map<DateTime, List<Activity>> activityDaysMap =
        Map<DateTime, List<Activity>>.fromIterable(listDates, value: (_) => []);

    for (final activity in list) {
      final activityDates = activity.takesPlacesDates();
      for (final date in activityDates) {
        if (activityDaysMap[date] != null) {
          activityDaysMap[date]!.add(activity);
        } else {
          activityDaysMap[date] = [activity];
        }
      }
    }

    List<ActivityDay> outList = [];
    activityDaysMap
        .forEach((key, value) => outList.add(ActivityDay(value, key)));

    return outList;
  }

  ActivityDay _formDay(List<Activity> activities, DateTime date) {
    date = DateUtils.dateOnly(date);
    // ignore: prefer_const_literals_to_create_immutables
    final activityDay = ActivityDay([], date);
    for (final activity in activities) {
      final activityDates = activity.takesPlacesDates();
      for (final activityDate in activityDates) {
        if (activityDate == date) {
          activityDay.activitiesInThisDay.add(activity);
        }
      }
    }
    return activityDay;
  }

  Future<Either<Failure, ActivityDay>> getActivitiesFromDate(
      DateTime date, int searchInTop) async {
    final result = await repository.getActivities(ammount: searchInTop);

    return result.fold((l) => Left(l), (r) {
      return Right(_formDay(r, date));
    });
  }
}

class LoadActivitiesParams {
  const LoadActivitiesParams({required this.ammount, this.skip});

  final int ammount;
  final int? skip;
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
