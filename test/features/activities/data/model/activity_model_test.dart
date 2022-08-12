import 'package:copilot/features/activities/data/models/activity_model.dart';
import 'package:copilot/features/activities/domain/entities/activity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ActivityModel sut;

  setUp(() {
    sut = ActivityModel(
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
}
