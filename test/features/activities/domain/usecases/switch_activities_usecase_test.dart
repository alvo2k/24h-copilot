import 'package:copilot/core/error/return_types.dart';
import 'package:copilot/features/activities/domain/entities/activity.dart';
import 'package:copilot/features/activities/domain/repositories/activity_repository.dart';
import 'package:copilot/features/activities/domain/usecases/insert_activity_usecase.dart';
import 'package:copilot/features/activities/domain/usecases/switch_activities_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'shared_mocks.dart';

void main() {
  late SwitchActivitiesUsecase sut;
  late MockActivityRepository mockRepository;

  setUp(() {
    mockRepository = MockActivityRepository();
    sut = SwitchActivitiesUsecase(mockRepository);
  });

  test(
    "should accept instance of ActivityRepository",
    () => expect(sut.repository, isA<ActivityRepository>()),
  );

  test(
    "should call repository and return its value",
    () async {
      var returned = Right<Failure, Activity>(Activity(
          id: 1,
          name: '',
          color: Colors.black,
          startTime: DateTime(1),
        ));
      when(mockRepository.switchActivities(any)).thenAnswer((_) async => returned);

      var result = await sut(const SwitchActivitiesParams(''));

      verify(mockRepository.switchActivities(any)).called(1);
      verifyNoMoreInteractions(mockRepository);
      expect(result, returned);
    },
  );
}
