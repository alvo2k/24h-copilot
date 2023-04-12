import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/common/data/models/activity_model.dart';
import '../../../../core/error/return_types.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/pie_chart_data.dart';
import '../repositories/pie_chart_data_repositoty.dart';

@LazySingleton()
class PieChartDataUsecase extends UseCase<PieChartData, PieChartDataParams> {
  PieChartDataUsecase(this.repository);

  final PieChartDataRepository repository;

  @override
  Future<Either<Failure, PieChartData>> call(PieChartDataParams params) async {
    final DateTime to = () {
      if (params.to == DateUtils.dateOnly(DateTime.now())) {
        return DateTime.now();
      }
      if (params.to == params.from) {
        return params.to.add(const Duration(days: 1));
      }
      return params.to.add(const Duration(days: 1));
    }();

    late Either<Failure, List<ActivityModel>> activities;
    if (params.to == DateUtils.dateOnly(DateTime.now())) {
      // because range picker returns date only if it's today - load the entire day
      activities = await repository.getActivities(params.from, DateTime.now());
    } else {
      activities = await repository.getActivities(params.from, to);
    }

    return activities.fold(
      (failure) => Left(failure),
      (activities) {
        List<Color> colorList = [];
        for (int i = 0; i < activities.length; i++) {
          if (!colorList.contains(activities[i].color)) {
            colorList.add(activities[i].color);
          }
          if (activities[i].startTime.isBefore(params.from)) {
            // dont count time before [from]
            activities[i] = activities[i].changeStartTime(params.from);
          }
          if (activities[i].endTime != null &&
              activities[i].endTime!.isAfter(to)) {
            // dont count time after [to]
            final endTime = to;
            activities[i] = activities[i].changeEndTime(endTime);
          }
          if (activities[i].endTime == null) {
            if (to == DateUtils.dateOnly(DateTime.now())) {
              activities[i] = activities[i].changeEndTime(DateTime.now());
            } else {
              activities[i] = activities[i].changeEndTime(to);
            }
          }
        }
        final data = PieChartData(
          activities: activities,
          colorList: colorList,
          dataMap: _dataMap(activities, params.from),
          from: params.from,
          to: params.to,
        );
        return Right(data);
      },
    );
  }

  Map<String, double> _dataMap(List<ActivityModel> activities, DateTime from) {
    Map<String, double> dataMap = {};
    for (final activity in activities) {      
      if (dataMap.containsKey(activity.name)) {
        dataMap[activity.name] = dataMap[activity.name]! +
            activity.durationSince(from).inMinutes.toDouble();
      } else {
        dataMap[activity.name] =
            activity.durationSince(from).inMinutes.toDouble();
      }
    }
    return dataMap;
  }
}

class PieChartDataParams {
  PieChartDataParams({required this.from, required this.to});

  final DateTime from;
  final DateTime to;
}

extension on ActivityModel {
  Duration durationSince(DateTime since) {
    late Duration totalDuration;
    if (endTime == null) {
      totalDuration = DateTime.now().difference(startTime);
    } else {
      totalDuration = endTime!.difference(startTime);
    }
    if (startTime.isBefore(since)) {
      totalDuration -= since.difference(startTime);
    }
    return totalDuration;
  }
}
