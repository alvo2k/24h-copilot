import 'dart:ui';

import 'package:copilot/core/error/return_types.dart';
import 'package:copilot/features/activities/domain/entities/activity.dart';
import 'package:copilot/features/activities/domain/repositories/activity_repository.dart';
import 'package:copilot/features/activities/domain/usecases/insert_activity_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'shared_mocks.dart';

void main() {
  late InsertActivityUsecase sut;
  late MockActivityRepository mockRepository;

  setUp(() {
    mockRepository = MockActivityRepository();
    sut = InsertActivityUsecase(mockRepository);
    when(mockRepository.hasActivitySettings(any)).thenAnswer(
      (_) async => const Right<Failure, bool>(true),
    );
  });

  test(
    "should accept instance of ActivityRepository",
    () => expect(sut.repository, isA<ActivityRepository>()),
  );
  test('should generate color if repository cant find it', () async {
    var returnActivity = Right<Failure, Activity>(tActivity);
    when(mockRepository.insertActivity(
      name: anyNamed('name'),
      startTime: anyNamed('startTime'),
      color: anyNamed('color'),
    )).thenAnswer((_) async => returnActivity);
    when(mockRepository.hasActivitySettings(any)).thenAnswer(
      (_) async => const Right<Failure, bool>(false),
    );

    await sut(
      InsertActivityParams(
        name: '',
        startTime: DateTime(1),
      ),
    );

    expect(
        verify(
          mockRepository.insertActivity(
            name: anyNamed('name'),
            startTime: anyNamed('startTime'),
            color: captureAnyNamed('color'),
          ),
        ).captured.first,
        isA<Color>());
  });
  group('should call repository and return its value:', () {
    const name = '';
    var startTime = DateTime(1);
    var endTime = DateTime(1);
    test(
      'without end time',
      () async {
        var returnWithoutEndTime = Right<Failure, Activity>(tActivity);
        when(mockRepository.insertActivity(
          name: anyNamed('name'),
          startTime: anyNamed('startTime'),
        )).thenAnswer((_) async => returnWithoutEndTime);

        var result = await sut(InsertActivityParams(
          name: name,
          startTime: startTime,
        ));

        verify(mockRepository.insertActivity(
          name: anyNamed('name'),
          startTime: anyNamed('startTime'),
        )).called(1);
        verify(mockRepository.hasActivitySettings(any)).called(1);
        verifyNoMoreInteractions(mockRepository);
        expect(result, returnWithoutEndTime);
      },
    );
    test(
      'with end time',
      () async {
        var returnWithEndTime = Right<Failure, Activity>(tActivity);
        when(mockRepository.insertActivity(
          name: anyNamed('name'),
          startTime: anyNamed('startTime'),
          endTime: anyNamed('endTime'),
        )).thenAnswer((_) async => returnWithEndTime);

        var result = await sut(
          InsertActivityParams(
            name: name,
            startTime: startTime,
            endTime: endTime,
          ),
        );

        verify(mockRepository.insertActivity(
          name: anyNamed('name'),
          startTime: anyNamed('startTime'),
          endTime: anyNamed('endTime'),
        )).called(1);
        verify(mockRepository.hasActivitySettings(any)).called(1);
        verifyNoMoreInteractions(mockRepository);
        expect(result, returnWithEndTime);
      },
    );
  });
}
