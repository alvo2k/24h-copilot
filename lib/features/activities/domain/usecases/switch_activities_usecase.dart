import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/return_types.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/extensions.dart';
import '../entities/activity.dart';
import '../repositories/activity_repository.dart';

@LazySingleton()
class SwitchActivitiesUsecase
    extends UseCase<Activity, SwitchActivitiesParams> {
  SwitchActivitiesUsecase(this.repository);

  final ActivityRepository repository;

  @override
  Future<Either<Failure, Activity>> call(SwitchActivitiesParams params) async {
    final switchResult = await repository.switchActivities(
      nextActivityName: params.nextActivityName,
      startTime: DateTime.now().toUtc(),
      color: RandomColor.generate,
    );
    
    return switchResult.fold(
      (failure) async => Left(failure),
      (activity) async => Right(activity),
    );
  }
}

class SwitchActivitiesParams {
  const SwitchActivitiesParams(this.nextActivityName);

  final String nextActivityName;
}
