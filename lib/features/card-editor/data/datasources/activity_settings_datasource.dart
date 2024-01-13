import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/common/data/datasources/activity_database.dart';

part 'activity_settings_datasource.g.dart';

abstract interface class ActivitySettingsDataSource {
  Stream<List<DriftActivityModel>> activitySettings();

  Future<DriftActivityModel> updateActivitySettings({
    required String activityName,
    required String newActivityName,
    required int newColorHex,
    required String? tags,
    required int? newGoal,
  });
}

@LazySingleton(as: ActivitySettingsDataSource)
@DriftAccessor(tables: [Activities, Records])
class ActivitySettingsDataSourceImpl extends DatabaseAccessor<ActivityDatabase>
    with _$ActivitySettingsDataSourceImplMixin
    implements ActivitySettingsDataSource {
  ActivitySettingsDataSourceImpl(super.db);

  @override
  Stream<List<DriftActivityModel>> activitySettings() =>
      select(activities).watch();

  @override
  Future<DriftActivityModel> updateActivitySettings({
    required String activityName,
    required String newActivityName,
    required int newColorHex,
    required String? tags,
    required int? newGoal,
  }) async {
    final companion = ActivitiesCompanion(
      name: Value(newActivityName),
      color: Value(newColorHex),
      tags: Value(tags),
      goal: newGoal == 0 ? const Value(null) : Value(newGoal),
    );

    final bool nameChanged = newActivityName != activityName;

    if (nameChanged) {
      return _updateWithNameChange(companion: companion, oldName: activityName);
    }

    final result = await (update(activities)..whereSamePrimaryKey(companion))
        .writeReturning(companion);

    return result[0];
  }

  Future<DriftActivityModel> _updateWithNameChange({
    required ActivitiesCompanion companion,
    required String oldName,
  }) async {
    final exists = (await (select(activities)
              ..where((a) => a.name.equals(companion.name.value)))
            .getSingleOrNull()) !=
        null;

    if (!exists) {
      await into(activities).insert(companion);
    }

    // change activityName in records
    await (update(records)..where((r) => r.activityName.equals(oldName)))
        .write(RecordsCompanion(activityName: Value(companion.name.value)));
    // delete activty that does not have any records any more
    await (delete(activities)..where((a) => a.name.equals(oldName))).go();

    return (select(activities)
          ..where((a) => a.name.equals(companion.name.value)))
        .getSingle();
  }
}
