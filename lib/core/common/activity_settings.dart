// ignore_for_file: public_member_api_docs, sort_constructors_first
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

  ActivitySettings copyWith({
    Color? color,
    int? goal,
    String? name,
    List<String>? tags,
    int? amount,
  }) {
    return ActivitySettings(
      color: color ?? this.color,
      goal: goal ?? this.goal,
      name: name ?? this.name,
      tags: tags ?? this.tags,
      amount: amount ?? this.amount,
    );
  }
}
