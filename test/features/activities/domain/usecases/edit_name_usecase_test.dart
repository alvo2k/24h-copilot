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
        color: anyNamed('color'),
      )).thenAnswer((_) async => Right(tActivity));

      var result = await sut(EditNameParams(tActivity.recordId, 'new name'));

      verify(mockRepository.editName(
        recordId: anyNamed('recordId'),
        newName: anyNamed('newName'),
        color: anyNamed('color'),
      )).called(1);
      verifyNoMoreInteractions(mockRepository);
      expect(result, Right(tActivity));
    },
  );
}
