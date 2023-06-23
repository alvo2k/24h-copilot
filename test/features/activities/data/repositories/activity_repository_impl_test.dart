import 'package:copilot/core/common/data/datasources/activity_database.dart';
import 'package:copilot/core/common/data/datasources/activity_local_data_source.dart';
import 'package:copilot/core/common/data/models/activity_model.dart';
import 'package:copilot/core/error/exceptions.dart';
import 'package:copilot/core/error/return_types.dart';
import 'package:copilot/features/activities/data/repositories/activity_repository_impl.dart';
import 'package:copilot/features/activities/domain/entities/edit_record.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([ActivityLocalDataSource])
import 'activity_repository_impl_test.mocks.dart';

// Broken Mockito methods in .mocks.dart
// _i4.Future<_i2.DriftActivityModel?> findActivitySettings(String? name) =>
//       (super.noSuchMethod(Invocation.method(#findActivitySettings, [name]),
//               returnValue: _i4.Future<_i2.DriftActivityModel?>.value(FakeDriftActivityModel()))
//           as _i4.Future<_i2.DriftActivityModel?>);
//   @override
//   _i4.Future<_i2.DriftActivityModel> createActivity(
//           String? name, int? colorHex) =>
//       (super.noSuchMethod(Invocation.method(#createActivity, [name, colorHex]),
//               returnValue: _i4.Future<_i2.DriftActivityModel>.value(FakeDriftActivityModel()))
//           as _i4.Future<_i2.DriftActivityModel>);

class FakeDriftActivityModel extends Fake implements DriftActivityModel {}

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
    sut = ActivityRepositoryImpl(mockLocalDataSource);
  });

  group('Load Activities:', () {
    test(
      'should return List<Activities> for the day',
      () async {
        when(mockLocalDataSource.getRecordsRange(
          from: date.millisecondsSinceEpoch,
          to: date.add(const Duration(days: 1)).millisecondsSinceEpoch,
        )).thenAnswer((_) async => Stream.value(rawActivities));

        final result = await sut.getActivities(
          from: date.millisecondsSinceEpoch,
          to: date.add(const Duration(days: 1)).millisecondsSinceEpoch,
        );

        expect((await result.first), [
          ActivityModel.fromDriftRow(
              rawActivities[0], DateTime(2).millisecondsSinceEpoch),
          ActivityModel.fromDriftRow(rawActivities[1]),
        ]);
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
            .thenAnswer((_) async => tDriftRow.activity);

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
          .thenAnswer((_) async => tDriftRow.activity);
      when(mockLocalDataSource.createRecord(
        activityName: anyNamed('activityName'),
        startTime: anyNamed('startTime'),
      )).thenAnswer((_) async => tDriftRow);
    });
    test(
      'should return ActivityModel on success',
      () async {
        final result = await sut.switchActivities(
          nextActivityName: 'name',
          startTime: DateTime(1),
          color: const Color(0xFF000000),
        );
        expect(result.isRight(), true);
        expect((result as Right).value, ActivityModel.fromDriftRow(tDriftRow));
      },
    );
    test(
      'should call createActivity if couldn\'t find activity settings',
      () async {
        when(mockLocalDataSource.findActivitySettings(any))
            .thenAnswer((_) async => null);
        when(mockLocalDataSource.createActivity(any, any))
            .thenAnswer((_) async => tDriftRow.activity);

        await sut.switchActivities(
          nextActivityName: 'name',
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
          .thenAnswer((_) async => tDriftRow.activity);
      when(mockLocalDataSource.createActivity(any, any))
          .thenAnswer((_) async => tDriftRow.activity);
      when(mockLocalDataSource.updateRecordSettings(
        activityName: anyNamed('activityName'),
        idRecord: anyNamed('idRecord'),
      )).thenAnswer((_) async => tDriftRow);
    });
    test(
      'should return ActivityModel on success',
      () async {
        final result = await sut.editName(
            recordId: 1, newName: '', color: const Color(0xFF000000));

        expect(result.isRight(), true);
        expect((result as Right).value, ActivityModel.fromDriftRow(tDriftRow));
      },
    );
    test(
      'should call createActivity if couldn\'t find activity settings',
      () async {
        when(mockLocalDataSource.findActivitySettings(any))
            .thenAnswer((_) async => null);

        await sut.editName(
          recordId: 1,
          newName: '',
          color: const Color(0xFFFFFFFF),
        );

        verify(mockLocalDataSource.createActivity(any, any)).called(1);
      },
    );
    test(
      'should return CacheFailure on CacheException',
      () async {
        when(mockLocalDataSource.findActivitySettings(any))
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
  group('Edit records: ', () {
    final testEditRecord = EditRecord(
      activityName: 'activityName',
      color: Colors.black,
      mode: EditMode.switchWithStartTime,
      startTime: DateTime.now(),
    );
    setUp(() {
      when(mockLocalDataSource.findActivitySettings(any))
          .thenAnswer((_) async => tDriftRow.activity);
      when(mockLocalDataSource.createRecord(
        activityName: anyNamed('activityName'),
        startTime: anyNamed('startTime'),
      )).thenAnswer((_) async => tDriftRow);
    });
    test('should return CacheFailure on CacheException', () async {
      when(mockLocalDataSource.findActivitySettings(any))
          .thenThrow(CacheException());

      final result = await sut.editRecords(testEditRecord);

      expect(result.isLeft(), true);
      expect((result as Left).value, const CacheFailure());
    });
    test('should create activity settings if coudn\'t find one', () async {
      when(mockLocalDataSource.findActivitySettings(any))
          .thenAnswer((_) async => null);
      when(mockLocalDataSource.createActivity(any, any))
          .thenAnswer((_) async => tDriftRow.activity);

      await sut.editRecords(testEditRecord);

      verify(mockLocalDataSource.findActivitySettings(any)).called(1);
      verify(mockLocalDataSource.createActivity(
        testEditRecord.activityName,
        testEditRecord.color.value,
      )).called(1);
    });
    test(
        'should twice call createRecord and return activity with endTime on placeInside mode',
        () async {
      final result = await sut.editRecords(EditRecord(
        activityName: tActivityModel.name,
        color: Colors.black,
        mode: EditMode.placeInside,
        startTime: tActivityModel.startTime,
        endTime: tActivityModel.endTime,
        toChange: tActivityModel,
      ));

      verify(mockLocalDataSource.createRecord(
        activityName: anyNamed('activityName'),
        startTime: anyNamed('startTime'),
      )).called(2);
      expect(result.isRight(), true);
      expect((result as Right).value, tActivityModel);
    });
    test(
        'should call createRecord and updateRecordTime and return activity with endTime on placeAbove mode',
        () async {
      when(mockLocalDataSource.updateRecordTime(
        idRecord: anyNamed('idRecord'),
        startTime: anyNamed('startTime'),
      )).thenAnswer((_) async {});

      final result = await sut.editRecords(EditRecord(
        activityName: tActivityModel.name,
        color: Colors.black,
        mode: EditMode.placeAbove,
        endTime: tActivityModel.endTime,
        toChange: tActivityModel,
      ));

      verify(mockLocalDataSource.createRecord(
        activityName: anyNamed('activityName'),
        startTime: anyNamed('startTime'),
      )).called(1);
      verify(mockLocalDataSource.updateRecordTime(
        idRecord: anyNamed('idRecord'),
        startTime: anyNamed('startTime'),
      )).called(1);
      expect(result.isRight(), true);
      expect((result as Right).value, tActivityModel);
    });
    test(
        'should create new record and return it with endTime on placeBellow mode',
        () async {
      final result = await sut.editRecords(EditRecord(
        activityName: tActivityModel.name,
        color: Colors.black,
        mode: EditMode.placeBellow,
        startTime: tActivityModel.startTime,
        toChange: tActivityModel,
      ));

      verify(mockLocalDataSource.createRecord(
        activityName: anyNamed('activityName'),
        startTime: anyNamed('startTime'),
      )).called(1);
      expect(result.isRight(), true);
      expect((result as Right).value, tActivityModel);
    });
    group('override mode: ', () {
      test(
          'should call updateRecordSettings and return activity with endTime if toChange.endTime exists',
          () async {
        when(mockLocalDataSource.updateRecordSettings(
          idRecord: anyNamed('idRecord'),
          activityName: anyNamed('activityName'),
        )).thenAnswer((_) async => tDriftRow);

        final result = await sut.editRecords(EditRecord(
          activityName: tActivityModel.name,
          color: Colors.black,
          mode: EditMode.override,
          toChange: tActivityModel,
        ));

        verify(mockLocalDataSource.updateRecordSettings(
          idRecord: anyNamed('idRecord'),
          activityName: anyNamed('activityName'),
        )).called(1);
        expect(result.isRight(), true);
        expect((result as Right).value, tActivityModel);
      });
      test(
          'should call updateRecordSettings and return activity with endTime == null',
          () async {
        when(mockLocalDataSource.updateRecordSettings(
          idRecord: anyNamed('idRecord'),
          activityName: anyNamed('activityName'),
        )).thenAnswer((_) async => tDriftRow);

        final activity = ActivityModel.fromDriftRow(tDriftRow);
        final result = await sut.editRecords(EditRecord(
          activityName: tActivityModel.name,
          color: Colors.black,
          mode: EditMode.override,
          toChange: activity,
        ));

        verify(mockLocalDataSource.updateRecordSettings(
          idRecord: anyNamed('idRecord'),
          activityName: anyNamed('activityName'),
        )).called(1);
        expect(result.isRight(), true);
        expect((result as Right).value, activity);
      });
    });
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
