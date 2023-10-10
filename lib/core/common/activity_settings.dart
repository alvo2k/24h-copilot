import 'dart:ui';

import 'package:equatable/equatable.dart';

import 'data/datasources/activity_database.dart';

class ActivitySettings extends Equatable {
  const ActivitySettings(
      {required this.name, this.tags, this.goal, required this.color});

  final Color color;
  final int? goal;
  final String name;
  final List<String>? tags;

  @override
  List<Object?> get props => [
        name,
        color,
        tags,
        goal,
      ];

  factory ActivitySettings.fromDrift(DriftActivityModel model) =>
      ActivitySettings(
        name: model.name,
        color: Color(model.color),
        goal: model.goal,
        tags: model.tags?.split(';'),
      );
}
