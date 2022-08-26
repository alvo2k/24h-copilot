import 'package:copilot/features/activities/data/datasources/drift/drift_db.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ActivityDatabase sut;

  setUp(() {
    sut = ActivityDatabase(NativeDatabase.memory(
      //logStatements: true,
    ));
  });

  tearDown(() async {
    await sut.close();
  });

  const activity = ActivitiesCompanion(
    name: Value('test'),
    color: Value(0),
    tags: Value('test'),
    goal: Value(1),
  );

  final record = RecordsCompanion(
    activityName: activity.name,
    startTime: const Value(1),
    endTime: const Value(2),
    emoji: const Value('test'),
  );
  test(
    'should add records and activity settings',
    () async {
      final activityId = await sut.addActivitySettings(activity);
      final recordId = await sut.addRecord(record);

      expect(activityId, 1);
      expect(recordId, 1);
    },
  );
  test(
    'should get records with activity',
    () async {
      await sut.addActivitySettings(activity);
      await sut.addRecord(record);

      final result = await sut.getRecords(1, 2);

      for (final e in result) {
        expect(e.activity.name, activity.name.value);
        expect(e.activity.color, activity.color.value);
        expect(e.activity.tags, activity.tags.value);
        expect(e.activity.goal, activity.goal.value);
        expect(e.record.activityName, record.activityName.value);
        expect(e.record.startTime, record.startTime.value);
        expect(e.record.endTime, record.endTime.value);
        expect(e.record.emoji, record.emoji.value);
      }
    },
  );
}
