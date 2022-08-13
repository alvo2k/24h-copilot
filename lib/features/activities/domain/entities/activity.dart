import 'dart:ui';

import 'package:equatable/equatable.dart';

part 'activity_settings.dart';

class Activity extends ActivitySettings with EquatableMixin {
  Activity({
    required this.recordId,
    required super.name,
    required super.color,
    required this.startTime,
    super.tags,
    this.endTime,
    super.goal,
    this.emoji,
  })  : assert(
          startTime.isUtc == false,
          'startTime in [Activity] should always be local',
        ),
        assert(
          endTime == null || endTime.isUtc == false,
          'endTime in [Activity] should always be local',
        );

  final String? emoji;
  final DateTime? endTime;
  final int recordId;
  final DateTime startTime;

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
