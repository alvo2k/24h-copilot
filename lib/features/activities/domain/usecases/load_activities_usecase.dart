import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/return_types.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/activity.dart';
import '../repositories/activity_repository.dart';

@LazySingleton()
class LoadActivitiesUsecase
    extends UseCase<List<Activity>, LoadActivitiesParams> {
  LoadActivitiesUsecase(this.repository);

  final ActivityRepository repository;

  @override
  Future<Either<Failure, List<Activity>>> call(
      LoadActivitiesParams params) async {
    return await repository.getActivities(params.forTheDay.toUtc());
  }
}

class LoadActivitiesParams {
  const LoadActivitiesParams(this.forTheDay);

  final DateTime forTheDay;
}
