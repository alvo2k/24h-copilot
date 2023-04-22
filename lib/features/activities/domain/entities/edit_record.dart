import 'dart:core';
import 'dart:ui';

import 'activity.dart';

class EditRecord {
  final String activityName;
  final Color color;
  final EditMode mode;
  final DateTime? startTime;
  final DateTime? endTime;
  final Activity? toChange;

  EditRecord({
    required this.activityName,
    required this.color,
    required this.mode,
    this.startTime,
    this.endTime,
    this.toChange,
  });
}

enum EditMode {
  switchWithStartTime,
  placeBellow,
  placeAbove,
  placeInside,
  override,
}
