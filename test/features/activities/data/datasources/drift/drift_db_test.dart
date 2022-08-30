import 'package:copilot/core/error/exceptions.dart';
import 'package:copilot/features/activities/data/datasources/data_sources_contracts.dart';
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

  const name = 'name';
  const color = 0xFFFFFFFF;
  final startTime = DateTime.now().toUtc().millisecondsSinceEpoch;

  populateDB() async {
    await sut.createActivity(name, color);
    await sut.createRecord(
      activityName: name,
      startTime: startTime,
    );
  }

  test(
    'should be instance of [ActivityLocalDataSource]',
    () async {
      expect(sut, isA<ActivityLocalDataSource>());
    },
  );
  test(
    'should create activity',
    () async {
      await populateDB();

      expect(
        await sut.activities.select().getSingle(),
        const DriftActivityModel(name: name, color: color),
      );
    },
  );
  group('Create record:', () {
    test(
      'should throw CacheException when activity is not found',
      () async {
        expect(
          () => sut.createRecord(
            activityName: name,
            startTime: startTime,
          ),
          throwsA(isA<CacheException>()),
        );
      },
    );
    test(
      'should insert record when activity is found',
      () async {
        await populateDB();

        expect(
          await sut.records.select().getSingle(),
          DriftRecordModel(
            idRecord: 1,
            activityName: name,
            startTime: startTime,
          ),
        );
      },
    );
    test(
      'should return complete row',
      () async {
        await sut.createActivity(name, color);

        final result = await sut.createRecord(
          activityName: name,
          startTime: startTime,
        );

        expect(
          result.activity,
          const DriftActivityModel(name: name, color: color),
        );
        expect(
          result.record,
          DriftRecordModel(
              idRecord: 1, activityName: name, startTime: startTime),
        );
      },
    );
  });
  group('Find activity settings:', () {
    test(
      'should return activity model when activity is found',
      () async {
        await populateDB();

        final result = await sut.findActivitySettings(name);

        expect(
          result,
          const DriftActivityModel(name: name, color: color),
        );
      },
    );
    test(
      'should return null when activity is not found',
      () async {
        final result = await sut.findActivitySettings(name);

        expect(result, null);
      },
    );
  });
  group('Get records:', () {
    late RecordWithActivitySettings row;
    final minute = const Duration(minutes: 1).inMilliseconds;
    final endTime = startTime + minute;
    setUp(() async {
      await sut.createActivity(name, color);
      row = await sut.createRecord(
        activityName: name,
        startTime: startTime,
        endTime: endTime,
      );
    });
    test(
      'should get records including endTime',
      () async {
        final result = await sut.getRecords(
          from: endTime,
          to: endTime + minute,
        );

        expect(
          result.first.activity,
          row.activity,
        );
        expect(
          result.first.record,
          row.record,
        );
      },
    );
    test(
      'should get records excluding startTime',
      () async {
        final result = await sut.getRecords(
          from: startTime - minute,
          to: startTime,
        );

        expect(
          result.isEmpty,
          true,
        );
      },
    );
  });
  test(
    'should add emoji',
    () async {
      await populateDB();

      await sut.updateRecordEmoji(
        1,
        'emoji',
      );

      expect(
        await sut.records.select().getSingle(),
        DriftRecordModel(
          idRecord: 1,
          activityName: name,
          startTime: startTime,
          emoji: 'emoji',
        ),
      );
    },
  );
  test(
    'should update record settings',
    () async {
      await populateDB();
      await sut.createActivity('name1', color);

      final result = await sut.updateRecordSettings(
        idRecord: 1,
        activityName: 'name1',
      );

      expect(result.record.activityName, 'name1');
    },
  );
  group('Update record time', () {
    final minute = const Duration(minutes: 1).inMilliseconds;
    final endTime = startTime + minute;
    test(
      'should update both record times',
      () async {
        await populateDB();

        await sut.updateRecordTime(
          idRecord: 1,
          startTime: startTime,
          endTime: endTime,
        );

        expect(
            await sut.records.select().getSingle(),
            DriftRecordModel(
              idRecord: 1,
              activityName: name,
              startTime: startTime,
              endTime: endTime,
            ));
      },
    );
    test(
      'should update records start time',
      () async {
        await populateDB();

        await sut.updateRecordTime(idRecord: 1, startTime: startTime + minute);

        expect(await sut.records.select().getSingle(),
            DriftRecordModel(
              idRecord: 1,
              activityName: name,
              startTime: startTime + minute,
            ));
      },
    );
    test(
      'should update records end time',
      () async {
        await populateDB();

        await sut.updateRecordTime(idRecord: 1, endTime: endTime);

        expect(await sut.records.select().getSingle(),
            DriftRecordModel(
              idRecord: 1,
              activityName: name,
              startTime: startTime,
              endTime: endTime,
            ));
      },
    );
  });
}
