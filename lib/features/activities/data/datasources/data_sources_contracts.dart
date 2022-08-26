import 'drift/drift_db.dart';

abstract class ActivityLocalDataSource {
  /// Gets list with all model fields.
  /// where [from] & [to] - DateTime().millisecondsSinceEpoch in UTC
  Future<List<RecordWithActivitySettings>> getRecords({
    required int from,
    required int to,
  });

  /// Inserts into records and returns class with all model fields
  Future<RecordWithActivitySettings> createRecord({
    required String activityName,
    required int startTime,
    int endTime,
  });

  /// Inserts into records and returns class with all model fields
  Future<void> updateRecordTime({
    required int idRecord,
    int startTime,
    int endTime,
  });

  /// Changes [acitivityName] field in record and returns map with all model fields
  Future<RecordWithActivitySettings> updateRecordSettings({
    required int idRecord,
    required String activityName,
  });

  /// Trys to find [Activity] fields (id, color, tags, goal...)
  Future<DriftActivityModel?> findActivitySettings(String name);

  /// Creates new [Activity] (name, color)
  Future<void> createActivity(String name, int colorHex);

  Future<void> updateRecordEmoji(int idRecord, String emoji);
}
