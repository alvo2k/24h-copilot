import 'package:injectable/injectable.dart';

import '../../../../core/common/activity_settings.dart';
import '../../../../core/utils/constants.dart';
import '../repositories/activity_repository.dart';

@LazySingleton()
class RecommendedActivitiesUsecase {
  RecommendedActivitiesUsecase(this.repository);

  final ActivityRepository repository;

  Stream<List<ActivitySettings>> call() => repository.mostCommonActivities(
        ammount: Constants.activitiesAmmountToRecommend,
      );
}
