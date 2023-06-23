import 'package:copilot/features/activities/domain/entities/activity_day.dart';
import 'package:copilot/features/activities/domain/repositories/activity_repository.dart';
import 'package:copilot/features/activities/domain/usecases/load_activities_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'shared_mocks.dart';

void main() {
  late LoadActivitiesUsecase sut;
  late MockActivityRepository mockRepository;

  setUp(() {
    mockRepository = MockActivityRepository();
    sut = LoadActivitiesUsecase(mockRepository);
  });

  test(
    "should accept instance of ActivityRepository",
    () => expect(sut.repository, isA<ActivityRepository>()),
  );
  test(
    "should call repository and return ActivityDay with callable date",
    () async {
      when(mockRepository.getActivities(
              from: anyNamed('from'), to: anyNamed('to')))
          .thenAnswer(
        (_) async => Stream.value([]),
      );

      final arg = DateTime(1);
      var result = await sut(LoadActivitiesParams(arg));

      verify(mockRepository.getActivities(
              from: anyNamed('from'), to: anyNamed('to')))
          .called(1);
      verifyNoMoreInteractions(mockRepository);
      expect((await result.first).date, arg);
    },
  );
  test(
    'should call repository with millisecondsSinceEpoch and with one day difference',
    () async {
      when(mockRepository.getActivities(
              from: anyNamed('from'), to: anyNamed('to')))
          .thenAnswer(
        (_) async => Stream.value([]),
      );

      final forTheDay = DateUtils.dateOnly(DateTime.now());
      await sut(LoadActivitiesParams(forTheDay));

      var result = verify(mockRepository.getActivities(
              from: captureAnyNamed('from'), to: captureAnyNamed('to')))
          .captured;
      expect(DateTime.fromMillisecondsSinceEpoch(result[0]), forTheDay);
      expect(DateTime.fromMillisecondsSinceEpoch(result[1]),
          forTheDay.add(const Duration(days: 1)));
    },
  );  
}
