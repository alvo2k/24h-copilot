import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class Activity extends Equatable {
  Activity({
    required this.name,
    required this.color,
    required this.startTime,
    this.tags,
    this.endTime,
    this.goal,
    this.emoji,
  })  : assert(startTime.isUtc == false,
          'startTime in [Activity] should always be local',
        ),
        assert(
          endTime == null || endTime.isUtc == false,
          'endTime in [Activity] should always be local',
        );

  final Color color;
  final String? emoji;
  final DateTime? endTime;
  final int? goal;
  final String name;
  final DateTime startTime;
  final List<String>? tags;

  @override
  List<Object?> get props => [
        name,
        color,
        startTime,
        tags,
        endTime,
        goal,
        emoji,
      ];
}
