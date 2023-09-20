import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/common/data/models/activity_model.dart';
import '../entities/pie_chart_data.dart';
import '../repositories/pie_chart_data_repositoty.dart';

@LazySingleton()
class PieChartDataUsecase {
  PieChartDataUsecase(this.repository);

  final PieChartDataRepository repository;

  Future<Stream<PieChartData>> call(PieChartDataParams params) async {
    final DateTime to = () {
      if (DateUtils.dateOnly(params.to) == DateUtils.dateOnly(DateTime.now())) {
        return DateUtils.dateOnly(DateTime.now()).add(const Duration(days: 1));
      }
      if (params.to == params.from) {
        return params.to.add(const Duration(days: 1));
      }
      return params.to.add(const Duration(days: 1));
    }();

    final activitiesStream = await repository.getActivities(
      from: params.from.toUtc().millisecondsSinceEpoch,
      to: to.toUtc().millisecondsSinceEpoch,
      search: params.search,
    );

    return activitiesStream.map(
      (result) => result.fold(
        (l) => throw l,
        (activities) {
          List<Color> colorList = [];
          Map<String, Duration> activitiesDuration = {};
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
            if (activitiesDuration.containsKey(activities[i].name)) {
              activitiesDuration[activities[i].name] =
                  activitiesDuration[activities[i].name]! +
                      activities[i].durationSince(params.from);
              activities.removeAt(i);
              i--;
            } else {
              activitiesDuration[activities[i].name] =
                  activities[i].durationSince(params.from);
            }
          }
          final data = PieChartData(
            activities: activities,
            colorList: colorList,
            dataMap: activitiesDuration
                .map((key, value) => MapEntry(key, value.inMinutes.toDouble())),
            from: params.from,
            to: params.to,
          );
          return data;
        },
      ),
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
    return repository.getFirstEverRecordStartTime();
  }
}

class PieChartDataParams {
  PieChartDataParams({
    required this.from,
    required this.to,
    this.search,
  });

  final DateTime from;
  final String? search;
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
