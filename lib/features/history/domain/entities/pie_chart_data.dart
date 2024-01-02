import 'dart:ui';

import 'package:equatable/equatable.dart';

import '../../../activities/domain/entities/activity.dart';

class PieChartData extends Equatable {
  PieChartData({
    required this.dataMap,
    required this.colorList,
    required this.activities,
    required this.from,
    required this.to,
  }) {
    assert(!from.isUtc);
    assert(!to.isUtc);
  }

  final List<Activity> activities;
  final List<Color> colorList;
  final Map<String, double> dataMap;
  final DateTime from;
  final DateTime to;

  @override
  List<Object> get props => [dataMap, colorList, activities, from, to];
}
