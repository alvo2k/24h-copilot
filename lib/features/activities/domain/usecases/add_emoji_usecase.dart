import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/return_types.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/activity_repository.dart';

@LazySingleton()
class AddEmojiUsecase extends UseCase<Success, AddEmojiParams> {
  AddEmojiUsecase(this.repository);

  final ActivityRepository repository;

  @override
  Future<Either<Failure, Success>> call(AddEmojiParams params) async {
    return repository.addEmoji(params.recordId, params.emoji);
  }
}

class AddEmojiParams {
  const AddEmojiParams(this.recordId, this.emoji);

  final String emoji;
  final int recordId;
}
