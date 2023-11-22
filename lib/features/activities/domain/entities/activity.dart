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
