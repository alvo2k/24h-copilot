import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/common/activity_settings.dart';
import '../../../../core/error/return_types.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/activity_settings_repository.dart';

@LazySingleton()
class LoadActivitiesSettingsUsecase extends UseCase<List<ActivitySettings>, LoadActivitiesSettingsParams> {
  LoadActivitiesSettingsUsecase(this._repository);

  final ActivitySettingsRepository _repository;

  @override
  Future<Either<Failure, List<ActivitySettings>>> call(LoadActivitiesSettingsParams params) {
    return _repository.loadActivitiesSettings();
  }
}

class LoadActivitiesSettingsParams {}