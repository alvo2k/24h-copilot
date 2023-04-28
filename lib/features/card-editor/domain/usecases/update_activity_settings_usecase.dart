import 'dart:ui';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/common/activity_settings.dart';
import '../../../../core/error/return_types.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/activity_settings_repository.dart';

@LazySingleton()
class UpdateActivitySettingsUsecase
    extends UseCase<ActivitySettings, UpdateActivitySettingsParams> {
  UpdateActivitySettingsUsecase(this._repository);

  final ActivitySettingsRepository _repository;

  @override
  Future<Either<Failure, ActivitySettings>> call(
      UpdateActivitySettingsParams params) {
    return _repository.updateActivitySettings(
      activityName: params.activityName,
      newActivityName: params.newActivityName,
      newColor: params.newColor,
      newGoal: params.newGoal,
      tags: params.tags,
    );
  }
}

class UpdateActivitySettingsParams {
  final String activityName;
  final String newActivityName;
  final Color newColor;
  final List<String>? tags;
  final int? newGoal;

  UpdateActivitySettingsParams({
    required this.activityName,
    required this.newActivityName,
    required this.newColor,
    this.tags,
    this.newGoal,
  });
}
