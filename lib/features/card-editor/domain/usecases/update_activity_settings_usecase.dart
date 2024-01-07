import 'dart:ui';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/common/activity_settings.dart';
import '../../../../core/error/return_types.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/constants.dart';
import '../entities/validation_errors.dart';
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

  ValidationErrors? validate(String activityName, List<String> tags) {
    if (activityName.trim().isEmpty) {
      return ValidationErrors.activityNameIsEmpty;
    }
    if (activityName.trim().length > Constants.maxActivityName) {
      return ValidationErrors.activityNameTooLong;
    }
    if (tags.join(';').length > Constants.maxTagsLength) {
      return ValidationErrors.tooManyTags;
    }
    return null;
  }
}

class UpdateActivitySettingsParams {
  UpdateActivitySettingsParams({
    required this.activityName,
    required this.newActivityName,
    required this.newColor,
    this.tags,
    this.newGoal,
  });

  final String activityName;
  final String newActivityName;
  final Color newColor;
  final int? newGoal;
  final List<String>? tags;
}
