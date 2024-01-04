import 'dart:math';

import 'package:equatable/equatable.dart';

import '../../../../core/common/activity_settings.dart';

class Activity extends ActivitySettings with EquatableMixin {
  Activity({
    required this.recordId,
    required super.name,
    required super.color,
    required this.startTime,
    required super.amount,
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

  bool get goalMet {
    final duration =
        (endTime ?? DateTime.now()).difference(startTime).inMinutes;
    if (goal != null && duration >= goal!) {
      return true;
    }
    return false;
  }

  bool get goalSet => goal != null;

  double get goalCompletion {
    if (goal == null) return 0.0;
    final duration =
        (endTime ?? DateTime.now()).difference(startTime).inMinutes;
    return min(duration / goal!, 1.0);
  }

  bool get canChangeEmoji {
    if (endTime == null) return false;

    final tooOld =
        endTime!.isBefore(DateTime.now().subtract(const Duration(hours: 1)));
    return !tooOld;
  }

  @override
  List<Object?> get props => [
        recordId,
        name,
        color,
        startTime,
        amount,
        tags,
        endTime,
        goal,
        emoji,
      ];
}
