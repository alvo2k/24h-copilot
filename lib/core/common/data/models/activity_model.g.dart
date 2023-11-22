// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivityModel _$ActivityModelFromJson(Map<String, dynamic> json) =>
    ActivityModel(
      idRecord: json['id_record'] as int,
      name: json['name'] as String,
      colorHex: json['color'] as int,
      startTimeUnix: json['start_time'] as int,
      amount: json['amount'] as int,
      inLineTags: json['tags'] as String?,
      endTimeUnix: json['end_time'] as int?,
      goal: json['goal'] as int?,
      emoji: json['emoji'] as String?,
    );

Map<String, dynamic> _$ActivityModelToJson(ActivityModel instance) =>
    <String, dynamic>{
      'goal': instance.goal,
      'name': instance.name,
      'amount': instance.amount,
      'emoji': instance.emoji,
      'color': instance.colorHex,
      'end_time': instance.endTimeUnix,
      'id_record': instance.idRecord,
      'tags': instance.inLineTags,
      'start_time': instance.startTimeUnix,
    };
