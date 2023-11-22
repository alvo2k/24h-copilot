import 'dart:ui';

import '../../../../core/common/activity_settings.dart';
import '../../../../core/common/data/datasources/activity_database.dart';

class ActivitySettingsModel extends ActivitySettings {
  const ActivitySettingsModel({
    required super.name,
    required super.amount,
    super.tags,
    super.goal,
    required super.color,
  });

  factory ActivitySettingsModel.fromDriftRow(DriftActivityModel row) => ActivitySettingsModel(
        name: row.name,
        tags: row.tags?.split(';'),
        goal: row.goal,
        color: Color(row.color),
        amount: row.amount,
      );
}
