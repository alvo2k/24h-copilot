import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/return_types.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/activity_repository.dart';

@LazySingleton()
class EditNameUsecase extends UseCase<Success, EditNameParams> {
  EditNameUsecase(this.repository);

  final ActivityRepository repository;

  @override
  Future<Either<Failure, Success>> call(EditNameParams params) async {
    return await repository.editName(params.idActivity, params.name);
  }
}

class EditNameParams {
  const EditNameParams(this.idActivity, this.name);

  final int idActivity;
  final String name;
}
