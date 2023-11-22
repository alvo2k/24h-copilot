import 'dart:ui';

import 'package:equatable/equatable.dart';

import 'data/datasources/activity_database.dart';

class ActivitySettings extends Equatable {
  const ActivitySettings({
    required this.name,
    required this.amount,
    required this.color,
    this.tags,
    this.goal,
  });

  final Color color;
  final int? goal;
  final String name;
  final List<String>? tags;
  final int amount;

  @override
  List<Object?> get props => [
        name,
        color,
        tags,
        goal,
        amount,
      ];

  factory ActivitySettings.fromDrift(DriftActivityModel model) =>
      ActivitySettings(
        name: model.name,
        color: Color(model.color),
        goal: model.goal,
        tags: model.tags?.split(';'),
        amount: model.amount,
      );
}
