import 'dart:ui';

import '../../domain/entities/activity.dart';

class ActivityModel extends Activity {
  ActivityModel({
    required super.recordId,
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
              DateTime.fromMillisecondsSinceEpoch(startTimeUnix, isUtc: true)
                  .toLocal(),
          tags: inLineTags?.split(';'),
          endTime: endTimeUnix != null
              ? DateTime.fromMillisecondsSinceEpoch(endTimeUnix, isUtc: true)
                  .toLocal()
              : null,
        );

  final int colorHex;
  final int? endTimeUnix;
  final String? inLineTags;
  final int startTimeUnix;
}
