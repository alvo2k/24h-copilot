import 'package:copilot/features/activities/domain/entities/activity.dart';
import 'package:copilot/features/activities/domain/repositories/activity_repository.dart';
import 'package:copilot/features/activities/domain/usecases/load_activities_usecase.dart';
import 'package:dartz/dartz.dart';

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
    "should call repository and return its value",
    () async {
      when(mockRepository.getActivities(any)).thenAnswer((_) async => const Right(<Activity>[]));

      var result = await sut(LoadActivitiesParams(DateTime(1)));

      verify(mockRepository.getActivities(any)).called(1);
      verifyNoMoreInteractions(mockRepository);
      expect(result, const Right(<Activity>[]));
    },
  );
}
