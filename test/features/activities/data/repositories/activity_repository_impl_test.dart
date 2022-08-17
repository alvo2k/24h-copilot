import 'dart:ui';

import 'package:copilot/core/error/exceptions.dart';
import 'package:copilot/core/error/return_types.dart';
import 'package:copilot/features/activities/data/datasources/activity_local_data_source.dart';
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
  final List<Map<String, dynamic>> rawActivities = [
    tActivityModel.toJson(),
    tActivityModel.toJson(),
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
        when(mockLocalDataSource.getActivities(
          from: date.millisecondsSinceEpoch,
          to: date
              .add(const Duration(
                  hours: 23, minutes: 59, seconds: 59, milliseconds: 999))
              .millisecondsSinceEpoch,
        )).thenAnswer((_) async => rawActivities);

        final result = await sut.getActivities(date);

        expect(result.isRight(), true);
        expect((result as Right).value, [tActivityModel, tActivityModel]);
      },
    );
    test(
      'should return CacheFailure on CacheException',
      () async {
        when(mockLocalDataSource.getActivities(
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
            'name', DateTime(1), const Color(0xFF000000));

        expect(result.isRight(), true);
        expect((result as Right).value, tActivityModel);
      },
    );
    test(
      'should return CacheFailure if couldn\'t find activity settings',
      () async {
        when(mockLocalDataSource.findActivitySettings(any))
            .thenAnswer((_) async => null);

        final result = await sut.switchActivities('name', DateTime(1));

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
            'name', DateTime(1), const Color(0xFF000000));

        expect(result.isLeft(), true);
        expect((result as Left).value, const CacheFailure());
      },
    );
  });
}
