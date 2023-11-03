import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/utils/constants.dart';

abstract class RecommendedActivitiesDataSource {
  List<String> mostCommonActivitiesNames(int amount);

  Future<void> countActivity(String activityName);
}

@LazySingleton(as: RecommendedActivitiesDataSource)
class RecommendedActivitiesDataSourceImpl
    extends RecommendedActivitiesDataSource {
  late Box _box;

  @PostConstruct(preResolve: true)
  Future<void> init() async {
    _box = await Hive.openBox(Constants.recommendedActivitiesBoxName);
  }

  @override
  List<String> mostCommonActivitiesNames(int amount) {
    assert(amount > 0);

    final sortedList = _box.toMap().entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    final outList = <String>[];
    for (int i = 0; i < amount && i < sortedList.length; i++) {
      outList.add(sortedList[i].key);
    }
    return outList;
  }

  @override
  Future<void> countActivity(String activityName) async {
    await _box.put(activityName, _box.get(activityName, defaultValue: 0) + 1);
  }
}
