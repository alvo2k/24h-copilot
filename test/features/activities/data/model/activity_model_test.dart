import 'package:copilot/features/activities/data/models/activity_model.dart';
import 'package:copilot/features/activities/domain/entities/activity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ActivityModel sut;

  setUp(() {
    sut = ActivityModel(
      idRecord: 1,
      name: 'Workout',
      colorHex: Colors.black.value,
      startTimeUnix: DateTime(1).millisecondsSinceEpoch,
      inLineTags: 'sport;work',
      endTimeUnix: DateTime(2).millisecondsSinceEpoch,
      emoji: '😎',
      goal: 10,
    );
  });

  test('should be a subclass of Activity entity',
      () => expect(sut, isA<Activity>()));

  group('passes correct values to super(): ', () {
    test(
      'color',
      () => expect(sut.color, Color(sut.colorHex)),
    );
    test(
      'startTime',
      () => expect(
        sut.startTime,
        DateTime.fromMillisecondsSinceEpoch(sut.startTimeUnix, isUtc: true)
            .toLocal(),
      ),
    );
    test(
      'tags',
      () => expect(sut.tags, sut.inLineTags?.split(';')),
    );
    test(
      'endTime',
      () {
        expect(
          sut.endTime,
          DateTime.fromMillisecondsSinceEpoch(sut.endTimeUnix!, isUtc: true)
              .toLocal(),
        );
      },
    );
  });
  group('json serializable', () {
    test(
      'to JSON',
      () {
        final json = sut.toJson();

        expect(json[ActivityModel.colIdRecord], sut.idRecord);
        expect(json[ActivityModel.colName], sut.name);
        expect(json[ActivityModel.colColor], sut.colorHex);
        expect(json[ActivityModel.colStartTime], sut.startTimeUnix);
        expect(json[ActivityModel.colTags], sut.inLineTags);
        expect(json[ActivityModel.colEndTime], sut.endTimeUnix);
        expect(json[ActivityModel.colGoal], sut.goal);
        expect(json[ActivityModel.colEmoji], sut.emoji);
      },
    );
    test(
      'from JSON',
      () {
        final json = sut.toJson();

        expect(ActivityModel.fromJson(json), sut);
      },
    );
  });
}
