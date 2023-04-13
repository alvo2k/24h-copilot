import 'dart:ui';

import 'package:json_annotation/json_annotation.dart';

import '../../../../features/activities/domain/entities/activity.dart';
import '../datasources/drift_db.dart';

part 'activity_model.g.dart';

@JsonSerializable()
class ActivityModel extends Activity {
  ActivityModel({
    required this.idRecord,
    required super.name,
    required this.colorHex,
    required this.startTimeUnix,
    this.inLineTags,
    this.endTimeUnix,
    super.goal,
    super.emoji,
  }) : super(
          recordId: idRecord,
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

  factory ActivityModel.fromDriftRow(RecordWithActivitySettings row) =>
      ActivityModel(
        idRecord: row.record.idRecord,
        name: row.activity.name,
        colorHex: row.activity.color,
        startTimeUnix: row.record.startTime,
        endTimeUnix: row.record.endTime,
        inLineTags: row.activity.tags,
        goal: row.activity.goal,
        emoji: row.record.emoji,
      );

  factory ActivityModel.fromJson(Map<String, dynamic> json) =>
      _$ActivityModelFromJson(json);

  static const colColor = 'color';
  static const colEmoji = 'emoji';
  static const colEndTime = 'end_time';
  static const colGoal = 'goal';
  static const colIdActivity = 'id_activity';
  static const colIdRecord = 'id_record';
  static const colName = 'name';
  static const colStartTime = 'start_time';
  static const colTags = 'tags';
  static const tblActivity = 'activity';
  static const tblRecords = 'records';

  @JsonKey(name: colColor)
  final int colorHex;

  @JsonKey(name: colEndTime)
  final int? endTimeUnix;

  @JsonKey(name: colIdRecord)
  final int idRecord;

  @JsonKey(name: colTags)
  final String? inLineTags;

  @JsonKey(name: colStartTime)
  final int startTimeUnix;

  Map<String, dynamic> toJson() => _$ActivityModelToJson(this);

  ActivityModel changeEndTime(DateTime endTime) => ActivityModel(
        idRecord: idRecord,
        name: name,
        colorHex: colorHex,
        startTimeUnix: startTimeUnix,
        emoji: emoji,
        endTimeUnix: endTime.toUtc().millisecondsSinceEpoch,
        goal: goal,
        inLineTags: inLineTags,
      );

  ActivityModel changeStartTime(DateTime startTime) => ActivityModel(
        idRecord: idRecord,
        name: name,
        colorHex: colorHex,
        startTimeUnix: startTime.toUtc().millisecondsSinceEpoch,
        emoji: emoji,
        endTimeUnix: endTimeUnix,
        goal: goal,
        inLineTags: inLineTags,
      );

  DriftRecordModel toDriftRecord() => DriftRecordModel(
        idRecord: idRecord,
        activityName: name,
        startTime: startTimeUnix,
        endTime: endTimeUnix,
        emoji: emoji,
      );

  DriftActivityModel toDriftActivity() => DriftActivityModel(
        name: name,
        color: colorHex,
        tags: inLineTags,
        goal: goal,
      );
}
