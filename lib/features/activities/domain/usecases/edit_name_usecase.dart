import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/return_types.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/activity.dart';
import '../repositories/activity_repository.dart';

@LazySingleton()
class EditNameUsecase extends UseCase<Activity, EditNameParams> {
  EditNameUsecase(this.repository);

  final ActivityRepository repository;

  @override
  Future<Either<Failure, Activity>> call(EditNameParams params) async {
    return await repository.editName(params.recordId, params.name);
  }
}

class EditNameParams {
  const EditNameParams(this.recordId, this.name);

  final String name;
  final int recordId;
}
