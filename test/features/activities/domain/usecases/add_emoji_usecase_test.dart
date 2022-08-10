import 'package:copilot/core/error/return_types.dart';
import 'package:copilot/features/activities/domain/repositories/activity_repository.dart';
import 'package:copilot/features/activities/domain/usecases/add_emoji_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'shared_mocks.dart';

void main() {
  late AddEmojiUsecase sut;
  late MockActivityRepository mockRepository;

  setUp(() {
    mockRepository = MockActivityRepository();
    sut = AddEmojiUsecase(mockRepository);
  });

  test(
    "should accept instance of ActivityRepository",
    () => expect(sut.repository, isA<ActivityRepository>()),
  );

  test(
    "should call repository and return its value",
    () async {
      when(mockRepository.addEmoji(any, any)).thenAnswer((_) async => const Right(Success()));

      var result = await sut(const AddEmojiParams(1, '🍆'));

      verify(mockRepository.addEmoji(any, any)).called(1);
      verifyNoMoreInteractions(mockRepository);
      expect(result, const Right(Success()));
    },
  );
}
