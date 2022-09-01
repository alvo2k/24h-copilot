import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/return_types.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/random_color.dart';
import '../entities/activity.dart';
import '../repositories/activity_repository.dart';

@LazySingleton()
class SwitchActivitiesUsecase
    extends UseCase<Activity, SwitchActivitiesParams> {
  SwitchActivitiesUsecase(this.repository);

  final ActivityRepository repository;

  @override
  Future<Either<Failure, Activity>> call(SwitchActivitiesParams params) async {
    return repository.switchActivities(
      nextActivityName: params.nextActivityName,
      startTime: DateTime.now().toUtc(),
      color: RandomColor.generate,
    );
  }
}

class SwitchActivitiesParams {
  const SwitchActivitiesParams(this.nextActivityName);

  final String nextActivityName;
}
