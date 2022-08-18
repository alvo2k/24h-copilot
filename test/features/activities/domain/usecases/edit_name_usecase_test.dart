import 'dart:ui';

import 'package:copilot/core/error/return_types.dart';
import 'package:copilot/features/activities/domain/entities/activity.dart';
import 'package:copilot/features/activities/domain/repositories/activity_repository.dart';
import 'package:copilot/features/activities/domain/usecases/edit_name_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'shared_mocks.dart';

void main() {
  late EditNameUsecase sut;
  late MockActivityRepository mockRepository;

  setUp(() {
    mockRepository = MockActivityRepository();
    sut = EditNameUsecase(mockRepository);

    when(mockRepository.hasActivitySettings(any)).thenAnswer(
      (_) async => const Right<Failure, bool>(true),
    );
  });

  test(
    "should accept instance of ActivityRepository",
    () => expect(sut.repository, isA<ActivityRepository>()),
  );

  test(
    "should call repository and return its value",
    () async {
      when(mockRepository.editName(
        recordId: anyNamed('recordId'),
        newName: anyNamed('newName'),
      )).thenAnswer((_) async => Right(tActivity));

      var result = await sut(EditNameParams(tActivity.recordId, 'new name'));

      verify(mockRepository.editName(
        recordId: anyNamed('recordId'),
        newName: anyNamed('newName'),
      )).called(1);
      verify(mockRepository.hasActivitySettings(any)).called(1);
      verifyNoMoreInteractions(mockRepository);
      expect(result, Right(tActivity));
    },
  );
  test(
    'should generate color if repository cant find it',
    () async {
      Future<Either<Failure, Activity>> exec() => mockRepository.editName(
            recordId: anyNamed('recordId'),
            newName: anyNamed('newName'),
            color: captureAnyNamed('color'),
          );
      final returnActivity = Right<Failure, Activity>(tActivity);
      when(exec()).thenAnswer((_) async => returnActivity);
      when(mockRepository.hasActivitySettings(any)).thenAnswer(
        (_) async => const Right<Failure, bool>(false),
      );

      final result = await sut(const EditNameParams(1, ''));

      expect(result, returnActivity);
      expect(verify(exec()).captured.first, isA<Color>());
      verify(mockRepository.hasActivitySettings(any)).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );
}
