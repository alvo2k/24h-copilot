import 'dart:ui';

import '../../domain/entities/activity.dart';

class ActivityModel extends Activity {
  final int startTimeUnix;
  final int? endTimeUnix;
  final int colorHex;
  final String? inLineTags;

  ActivityModel({
    required super.name,
    required this.colorHex,
    required this.startTimeUnix,
    this.inLineTags,
    this.endTimeUnix,
    super.goal,
    super.emoji,
  }) : super(
          color: Color(colorHex),
          startTime:
              DateTime.fromMillisecondsSinceEpoch(startTimeUnix, isUtc: true),
          tags: inLineTags?.split(';'),
          endTime: endTimeUnix != null
              ? DateTime.fromMillisecondsSinceEpoch(endTimeUnix, isUtc: true)
              : null,
        );
}
