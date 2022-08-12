import 'package:copilot/core/error/return_types.dart';
import 'package:copilot/features/activities/domain/entities/activity.dart';
import 'package:copilot/features/activities/domain/repositories/activity_repository.dart';
import 'package:copilot/features/activities/domain/usecases/insert_activity_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'shared_mocks.dart';

void main() {
  late InsertActivityUsecase sut;
  late MockActivityRepository mockRepository;

  setUp(() {
    mockRepository = MockActivityRepository();
    sut = InsertActivityUsecase(mockRepository);
  });

  test(
    "should accept instance of ActivityRepository",
    () => expect(sut.repository, isA<ActivityRepository>()),
  );

  group('should call repository and return its value: ', () {
    const name = '';
    var startTime = DateTime(1);
    var endTime = DateTime(1);
    test(
      'without end time',
      () async {
        var returnWithoutEndTime = Right<Failure, Activity>(Activity(
          name: '',
          color: Colors.black,
          startTime: DateTime(1),
        ));
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
        verifyNoMoreInteractions(mockRepository);
        expect(result, returnWithoutEndTime);
      },
    );
    test(
      'with end time',
      () async {
        var returnWithEndTime = Right<Failure, Activity>(Activity(
          name: '',
          color: Colors.black,
          startTime: DateTime(1),
        ));
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
        verifyNoMoreInteractions(mockRepository);
        expect(result, returnWithEndTime);
      },
    );
  });
}
