import 'dart:core';
import 'dart:ui';

import 'activity.dart';

class EditRecord {
  EditRecord({
    required this.activityName,
    required this.color,
    required this.mode,
    this.startTime,
    this.endTime,
    this.toChange,
  });

  final String activityName;
  final Color color;
  final DateTime? endTime;
  final EditMode mode;
  final DateTime? startTime;
  final Activity? toChange;
}

enum EditMode {
  switchWithStartTime,
  placeBellow,
  placeAbove,
  placeInside,
  override,
}
