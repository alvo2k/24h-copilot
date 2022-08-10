import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/return_types.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/activity.dart';
import '../repositories/activity_repository.dart';

@LazySingleton()
class InsertActivityUsecase extends UseCase<Activity, InsertActivityParams> {
  InsertActivityUsecase(this.repository);

  final ActivityRepository repository;

  @override
  Future<Either<Failure, Activity>> call(InsertActivityParams params) async {
    if (params.endTime != null) {
      return await repository.insertActivity(
          name: params.name,
          startTime: params.startTime,
          endTime: params.endTime!);
    } else {
      return await repository.insertActivity(
          name: params.name, startTime: params.startTime);
    }
  }
}

class InsertActivityParams {
  const InsertActivityParams({
    required this.name,
    required this.startTime,
    this.endTime,
  });

  final DateTime? endTime;
  final String name;
  final DateTime startTime;
}
