import 'package:injectable/injectable.dart';

import '../../../../core/common/activity_settings.dart';
import '../repositories/activity_settings_repository.dart';

@LazySingleton()
class LoadActivitiesSettingsUsecase {
  LoadActivitiesSettingsUsecase(this._repository);

  final ActivitySettingsRepository _repository;

  Stream<List<ActivitySettings>> call() {
    return _repository.loadActivitiesSettings();
  }
}
