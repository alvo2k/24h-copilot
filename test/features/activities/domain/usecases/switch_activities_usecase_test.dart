import 'package:copilot/core/error/return_types.dart';
import 'package:copilot/features/activities/domain/entities/activity.dart';
import 'package:copilot/features/activities/domain/repositories/activity_repository.dart';
import 'package:copilot/features/activities/domain/usecases/switch_activities_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'shared_mocks.dart';

void main() {
  late SwitchActivitiesUsecase sut;
  late MockActivityRepository mockRepository;

  setUp(() {
    mockRepository = MockActivityRepository();
    sut = SwitchActivitiesUsecase(mockRepository);
    when(mockRepository.hasActivitySettings(any)).thenAnswer(
      (_) async => const Right<Failure, bool>(true),
    );
  });

  test(
    "should accept instance of ActivityRepository",
    () => expect(sut.repository, isA<ActivityRepository>()),
  );
  test(
    'should call repository with DateTime in UTC format',
    () async {
      final returned = Right<Failure, Activity>(tActivity);
      when(mockRepository.switchActivities(
        nextActivityName: anyNamed('nextActivityName'),
        startTime: anyNamed('startTime'),
        color: anyNamed('color'),
      )).thenAnswer((_) async => returned);

      await sut(const SwitchActivitiesParams(''));

      var result = verify(mockRepository.switchActivities(
        nextActivityName: anyNamed('nextActivityName'),
        startTime: captureAnyNamed('startTime'),
        color: anyNamed('color'),
      ))
          .captured
          .first;
      expect(result.isUtc, true);
    },
  );
  test(
    "should call repository and return its value",
    () async {
      var returned = Right<Failure, Activity>(tActivity);
      when(mockRepository.switchActivities(
        nextActivityName: anyNamed('nextActivityName'),
        startTime: anyNamed('startTime'),
        color: anyNamed('color'),
      ))
          .thenAnswer((_) async => returned);

      var result = await sut(const SwitchActivitiesParams(''));

      verify(mockRepository.switchActivities(
        nextActivityName: anyNamed('nextActivityName'),
        startTime: anyNamed('startTime'),
        color: anyNamed('color'),
      )).called(1);
      verifyNoMoreInteractions(mockRepository);
      expect(result, returned);
    },
  );
}
