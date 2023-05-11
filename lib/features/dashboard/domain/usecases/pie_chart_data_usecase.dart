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
    final firstDate = await firstRecordDate();
    if (firstDate == null) {
      return const Left(CacheFailure({'message': 'No records found'}));
    }

    final from = () {
      if (params.from.isBefore(firstDate)) {
        return firstDate;
      }
      return params.from;
    }();

    final DateTime to = () {
      if (params.to == DateUtils.dateOnly(DateTime.now())) {
        return DateTime.now();
      }
      if (params.to == from) {
        return params.to.add(const Duration(days: 1));
      }
      return params.to.add(const Duration(days: 1));
    }();    

    late Either<Failure, List<ActivityModel>> activities;
    if (DateUtils.dateOnly(params.to) == DateUtils.dateOnly(DateTime.now())) {
      // because range picker returns date only if it's today - load the entire day
      activities = await repository.getActivities(
        from: from,
        to: DateTime.now(),
        search: params.search,
      );
    } else {
      activities = await repository.getActivities(
        from: from,
        to: to,
        search: params.search,
      );
    }

    return activities.fold(
      (failure) => Left(failure),
      (activities) {
        List<Color> colorList = [];
        Map<String, Duration> activitiesDuration = {};
        for (int i = 0; i < activities.length; i++) {
          if (!colorList.contains(activities[i].color)) {
            colorList.add(activities[i].color);
          }
          if (activities[i].startTime.isBefore(from)) {
            // dont count time before [from]
            activities[i] = activities[i].changeStartTime(from);
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
          if (activitiesDuration.containsKey(activities[i].name)) {
            activitiesDuration[activities[i].name] =
                activitiesDuration[activities[i].name]! +
                    activities[i].durationSince(from);
            activities.removeAt(i);
            i--;
          } else {
            activitiesDuration[activities[i].name] =
                activities[i].durationSince(from);
          }
        }
        final data = PieChartData(
          activities: activities,
          colorList: colorList,
          dataMap: activitiesDuration
              .map((key, value) => MapEntry(key, value.inMinutes.toDouble())),
          from: from,
          to: params.to,
        );
        return Right(data);
      },
    );
  }

  Future<List<String>> getSuggestions(String search) async {
    final suggestions = await repository.getSuggestion(search);
    return suggestions.fold(
      (failure) => [],
      (suggestions) => suggestions,
    );
  }

  Future<DateTime?> firstRecordDate() {
    return repository.getFirstRecord();
  }
}

class PieChartDataParams {
  PieChartDataParams({
    required this.from,
    required this.to,
    this.search,
  });

  final DateTime from;
  final DateTime to;
  final String? search;
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
