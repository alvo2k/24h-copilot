import 'drift_db.dart';

mixin ActivityLocalDataSource {
  /// Gets list with all model fields.
  /// amount - ammount of records; skip - ammount of skiped records
  Future<List<RecordWithActivitySettings>> getRecords({
    required int ammount,
    int? skip,
  });

  Future<List<RecordWithActivitySettings>> getRecordsRange({
    required int from,
    required int to,
  });

  Future<List<RecordWithActivitySettings>> getRecordsRangeWithTag({
    required int from,
    required int to,
    required String tag,
  });

  Future<DriftRecordModel?> getFirstRecord();

  Future<List<DriftActivityModel>> getActivitiesSettings();

  Future<DriftActivityModel> updateActivitySettings({
    required String activityName,
    required String newActivityName,
    required int newColorHex,
    required String? tags,
    required int? newGoal,
  });

  /// Inserts into records and returns class with all model fields
  Future<RecordWithActivitySettings> createRecord({
    required String activityName,
    required int startTime,
  });

  /// Inserts into records and returns class with all model fields
  Future<void> updateRecordTime({
    required int idRecord,
    required int startTime,
  });

  /// Changes [acitivityName] field in record and returns map with all model fields
  Future<RecordWithActivitySettings> updateRecordSettings({
    required int idRecord,
    required String activityName,
  });

  Future<int> getLastRecordId();

  /// Trys to find [Activity] fields (color, tags, goal...)
  Future<DriftActivityModel?> findActivitySettings(String name);

  /// Creates new [Activity] (name, color)
  Future<DriftActivityModel> createActivity(String name, int colorHex);

  Future<void> updateRecordEmoji(int idRecord, String emoji);

  Future<List<String>?> searchActivities(String activityName);

  Future<List<String>> searchTags(String tag);
}
