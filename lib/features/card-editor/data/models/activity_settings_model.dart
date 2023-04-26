import 'dart:ui';

import 'package:copilot/core/common/activity_settings.dart';
import 'package:copilot/core/common/data/datasources/drift_db.dart';

class ActivitySettingsModel extends ActivitySettings {
  const ActivitySettingsModel({
    required super.name,
    super.tags,
    super.goal,
    required super.color,
  });

  factory ActivitySettingsModel.fromDriftRow(DriftActivityModel row) => ActivitySettingsModel(
        name: row.name,
        tags: row.tags?.split(';'),
        goal: row.goal,
        color: Color(row.color),
      );
}
