import 'dart:ui';

import 'package:copilot/core/error/exceptions.dart';
import 'package:copilot/core/error/return_types.dart';
import 'package:copilot/features/activities/data/datasources/data_sources_contracts.dart';
import 'package:copilot/features/activities/data/models/activity_model.dart';
import 'package:copilot/features/activities/data/repositories/activity_repository_impl.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([ActivityLocalDataSource])
import 'activity_repository_impl_test.mocks.dart';

void main() {
  late ActivityRepositoryImpl sut;
  late MockActivityLocalDataSource mockLocalDataSource;

  final tActivityModel = ActivityModel(
    idRecord: 0,
    name: 'name',
    colorHex: 0xFF000000,
    startTimeUnix: DateTime(1).toUtc().millisecondsSinceEpoch,
    inLineTags: 'sport;body',
    emoji: '🤪',
    endTimeUnix: DateTime(2).toUtc().millisecondsSinceEpoch,
    goal: 1,
  );
  final tDriftRow = RecordWithActivitySettings(
    DriftRecordModel(
      idRecord: 0,
      activityName: 'name',
      startTime: DateTime(1).toUtc().millisecondsSinceEpoch,
      endTime: DateTime(2).toUtc().millisecondsSinceEpoch,
      emoji: '🤪',
    ),
    const DriftActivityModel(
      name: 'name',
      color: 0xFF000000,
      tags: 'sport;body',
      goal: 1,
    ),
  );
  final List<RecordWithActivitySettings> rawActivities = [
    tDriftRow,
    RecordWithActivitySettings(
      DriftRecordModel(
        idRecord: 1,
        startTime: DateTime(2).toUtc().millisecondsSinceEpoch,
        endTime: DateTime(3).toUtc().millisecondsSinceEpoch,
        emoji: '🤪',
        activityName: 'name2',
      ),
      const DriftActivityModel(
        name: 'name2',
        color: 0xFF000000,
        tags: 'sport;body',
        goal: 1,
      ),
    ),
  ];
  final date = DateTime(1).toUtc();

  setUp(() {
    mockLocalDataSource = MockActivityLocalDataSource();
    sut = ActivityRepositoryImpl(localDataSource: mockLocalDataSource);
  });

  group('Load Activities:', () {
    test(
      'should return List<Activities> for the day',
      () async {
        when(mockLocalDataSource.getRecords(
          from: date.millisecondsSinceEpoch,
          to: date.add(const Duration(days: 1)).millisecondsSinceEpoch,
        )).thenAnswer((_) async => rawActivities);

        final result = await sut.getActivities(date);

        expect(result.isRight(), true);
        expect((result as Right).value, [tActivityModel, tActivityModel]);
      },
    );
    test(
      'should return CacheFailure on CacheException',
      () async {
        when(mockLocalDataSource.getRecords(
          from: anyNamed('from'),
          to: anyNamed('to'),
        )).thenThrow(CacheException());

        final result = await sut.getActivities(date);

        expect(result.isLeft(), true);
        expect((result as Left).value, isA<CacheFailure>());
      },
    );
  });
  group('Has activity settings:', () {
    test(
      'should return false on null',
      () async {
        when(mockLocalDataSource.findActivitySettings(any))
            .thenAnswer((_) async => null);

        final result = await sut.hasActivitySettings('');

        expect(result.isRight(), true);
        expect((result as Right).value, false);
      },
    );
    test(
      'should return true on found activity',
      () async {
        when(mockLocalDataSource.findActivitySettings(any))
            .thenAnswer((_) async => {});

        final result = await sut.hasActivitySettings('');

        expect(result.isRight(), true);
        expect((result as Right).value, true);
      },
    );
    test(
      'should return CacheFailure on CacheException',
      () async {
        when(mockLocalDataSource.findActivitySettings(any))
            .thenThrow(CacheException());

        final result = await sut.hasActivitySettings('');

        expect(result.isLeft(), true);
        expect((result as Left).value, const CacheFailure());
      },
    );
  });
  group('Switch activities:', () {
    setUp(() {
      when(mockLocalDataSource.findActivitySettings(any))
          .thenAnswer((_) async => {ActivityModel.colIdActivity: 1});
      when(mockLocalDataSource.createRecord(
        idActivity: anyNamed('idActivity'),
        startTime: anyNamed('startTime'),
      )).thenAnswer((_) async => tActivityModel.toJson());
    });
    test(
      'should create activity if color was passed',
      () async {
        when(mockLocalDataSource.createActivity(any, any))
            .thenAnswer((_) async {});

        final result = await sut.switchActivities(
          nextActivityName: 'name',
          startTime: DateTime(1),
          color: const Color(0xFF000000),
        );

        expect(result.isRight(), true);
        expect((result as Right).value, tActivityModel);
      },
    );
    test(
      'should return CacheFailure if couldn\'t find activity settings',
      () async {
        when(mockLocalDataSource.findActivitySettings(any))
            .thenAnswer((_) async => null);

        final result = await sut.switchActivities(
          nextActivityName: 'name',
          startTime: DateTime(1),
          color: const Color(0xFF000000),
        );

        expect(result.isLeft(), true);
        expect((result as Left).value, const CacheFailure());
      },
    );
    test(
      'should return CacheFailure on CacheException',
      () async {
        when(mockLocalDataSource.createActivity(any, any))
            .thenThrow(CacheException());

        final result = await sut.switchActivities(
          nextActivityName: 'name',
          startTime: DateTime(1),
          color: const Color(0xFF000000),
        );

        expect(result.isLeft(), true);
        expect((result as Left).value, const CacheFailure());
      },
    );
  });
  group('Edit name:', () {
    setUp(() {
      when(mockLocalDataSource.findActivitySettings(any))
          .thenAnswer((_) async => {ActivityModel.colIdActivity: 1});
      when(mockLocalDataSource.createActivity(any, any))
          .thenAnswer((_) async => tActivityModel.toJson());
    });
    test(
      'should create activity if color was passed',
      () async {
        when(mockLocalDataSource.updateRecordSettings(
          activityName: anyNamed('activityName'),
          idRecord: anyNamed('idRecord'),
        )).thenAnswer((_) async => tActivityModel.toJson());

        final result = await sut.editName(
            recordId: 1, newName: '', color: const Color(0xFF000000));

        expect(result.isRight(), true);
        expect((result as Right).value, tActivityModel);
      },
    );
    test(
      'should return CacheFailure if couldn\'t find activity settings',
      () async {
        when(mockLocalDataSource.findActivitySettings(any))
            .thenAnswer((_) async => null);

        final result = await sut.editName(
          recordId: 1,
          newName: '',
          color: const Color(0xFFFFFFFF),
        );

        expect(result.isLeft(), true);
        expect((result as Left).value, const CacheFailure());
      },
    );
    test(
      'should return CacheFailure on CacheException',
      () async {
        when(mockLocalDataSource.createActivity(any, any))
            .thenThrow(CacheException());

        final result = await sut.editName(
          recordId: 1,
          newName: '',
          color: const Color(0xFF000000),
        );

        expect(result.isLeft(), true);
        expect((result as Left).value, const CacheFailure());
      },
    );
  });
  group('Insert activity', () {
    setUp(() {
      when(mockLocalDataSource.findActivitySettings(any))
          .thenAnswer((_) async => tDriftRow.activity);
      when(mockLocalDataSource.createRecord(
        activityName: anyNamed('activityName'),
        startTime: anyNamed('startTime'),
      )).thenAnswer((_) async => tDriftRow);
    });
    test(
      'should return ActivityModel on success (without endTime)',
      () async {
        final result = await sut.insertActivity(
          name: 'name',
          startTime: DateTime(1),
          color: const Color(0xFF000000),
        );

        expect(result.isRight(), true);
        expect((result as Right).value, tActivityModel);
      },
    );
    test(
      'should return ActivityModel on success (with endTime)',
      () async {
        when(mockLocalDataSource.createRecord(
          activityName: anyNamed('activityName'),
          startTime: anyNamed('startTime'),
          endTime: anyNamed('endTime'),
        )).thenAnswer((_) async => tDriftRow);
        final result = await sut.insertActivity(
          name: 'name',
          startTime: DateTime(1),
          color: const Color(0xFF000000),
          endTime: DateTime(2),
        );

        expect(result.isRight(), true);
        expect((result as Right).value, tActivityModel);
      },
    );
    test(
      'should should call createActivity if couldn\'t find activity settings',
      () async {
        when(mockLocalDataSource.findActivitySettings(any))
            .thenAnswer((_) async => null);
        when(mockLocalDataSource.createActivity(any, any))
            .thenAnswer((_) async => tDriftRow.activity);

        await sut.insertActivity(
          name: 'name',
          startTime: DateTime(1),
          color: const Color(0xFF000000),
        );

        verify(mockLocalDataSource.createActivity(any, any)).called(1);
      },
    );
    test(
      'should return CacheFailure on CacheException',
      () async {
        when(mockLocalDataSource.findActivitySettings(any))
            .thenThrow(CacheException());

        final result = await sut.insertActivity(
          name: 'name',
          startTime: DateTime(1),
          color: const Color(0xFF000000),
        );

        expect(result.isLeft(), true);
        expect((result as Left).value, const CacheFailure());
      },
    );
  });
  group('Add emoji', () {
    test(
      'should update record with new emoji',
      () async {
        when(mockLocalDataSource.updateRecordEmoji(any, any))
            .thenAnswer((_) async {});

        final result = await sut.addEmoji(1, 'emoji');

        expect(result.isRight(), true);
        expect((result as Right).value, const Success());
      },
    );
    test(
      'should return CacheFailure on CacheException',
      () async {
        when(mockLocalDataSource.updateRecordEmoji(any, any))
            .thenThrow(CacheException());

        final result = await sut.addEmoji(1, 'emoji');

        expect(result.isLeft(), true);
        expect((result as Left).value, const CacheFailure());
      },
    );
  });
}
