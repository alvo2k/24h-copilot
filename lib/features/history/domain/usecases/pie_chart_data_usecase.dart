import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/common/activity_settings.dart';
import '../../../../core/common/data/models/activity_model.dart';
import '../entities/pie_chart_data.dart';
import '../repositories/pie_chart_data_repositoty.dart';

@LazySingleton()
class PieChartDataUsecase {
  PieChartDataUsecase(this.repository);

  final PieChartDataRepository repository;

  Future<Stream<PieChartData?>> call(PieChartDataParams params) async {
    assert(params.to == DateUtils.dateOnly(params.to));

    // add one day because DateTimePicker returns date only
    // example:
    // from: 17.09.2023; to: 17.09.2023
    // and we want
    // from: 17.09.2023; to: 18.09.2023, [to] not included
    final DateTime to = params.to.add(const Duration(days: 1));

    final activitiesStream = await repository.getActivities(
      from: params.from.toUtc().millisecondsSinceEpoch,
      to: to.toUtc().millisecondsSinceEpoch,
      search: params.search,
    );

    return activitiesStream.map(
      (result) => result.fold(
        (l) => null,
        (activities) {
          final List<ActivityModel> duplicates = [];
          final Map<String, Duration> activitiesDuration = {};
          for (int i = 0; i < activities.length; i++) {
            if (activities[i].startTime.isBefore(params.from)) {
              // dont count time before [from]
              activities[i] = activities[i].changeStartTime(params.from);
            }
            if (activities[i].endTime != null &&
                activities[i].endTime!.isAfter(to)) {
              // dont count time after [to]
              activities[i] = activities[i].changeEndTime(to);
            } else if (activities[i].endTime == null) {
              // so that view can correctly calculate Activity duration
              activities[i] = activities[i].changeEndTime(
                  to.isAfter(DateTime.now()) ? DateTime.now() : to);
            }
            if (activitiesDuration.containsKey(activities[i].name)) {
              activitiesDuration[activities[i].name] =
                  activitiesDuration[activities[i].name]! +
                      activities[i]
                          .durationBetween(params.from, activities[i].endTime!);
              duplicates.add(activities[i]);
            } else {
              activitiesDuration[activities[i].name] = activities[i]
                  .durationBetween(params.from, activities[i].endTime!);
            }
          }
          for (final duplicate in duplicates) {
            activities.remove(duplicate);
          }
          final List<Color> colorList = [];
          for (final activity in activities) {
            colorList.add(activity.color);
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

  Future<List<ActivitySettings>> searchActivities(String search) async {
    return await repository.searchActivities(search);
  }

  Future<List<String>> searchTags(String search) async {
    return await repository.searchTags(search);
  }

  Future<DateTime?> firstRecordDate() {
    return repository.getFirstEverRecordStartTime();
  }

  Future<({DateTime from, DateTime to})> datesForInitialData() async {
    final today = DateUtils.dateOnly(DateTime.now());
    final firstRecord = await firstRecordDate();

    if (firstRecord != null) {
      if (firstRecord.isAfter(today.subtract(const Duration(days: 7)))) {
        return (from: firstRecord, to: today);
      }
      return (
        from: firstRecord.subtract(const Duration(days: 7)),
        to: today,
      );
    } else {
      return (from: today, to: today);
    }
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
