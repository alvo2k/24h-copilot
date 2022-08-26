abstract class ActivityLocalDataSource {
  /// Gets List of raw [Activities].
  /// where [from] & [to] - DateTime().millisecondsSinceEpoch in UTC
  Future<List<Map<String, dynamic>>> getRecords({
    required int from,
    required int to,
  });

  /// Inserts into records and returns map with all model fields
  Future<Map<String, dynamic>> createRecord({
    required int idActivity,
    required DateTime startTime,
    DateTime endTime,
  });

  Future<void> updateRecordTime({
    required int idRecord,
    DateTime startTime,
    DateTime endTime,
  });

  /// Changes activityId field in record and returns map with all model fields
  Future<Map<String, dynamic>> updateRecordSettings({
    required int idRecord,
    required int idActivity,
  });

  /// Trys to find [Activity] fields (id, color, tags, goal...)
  Future<Map<String, dynamic>?> findActivitySettings(String name);

  /// Creates new [Activity] (name, color)
  Future<void> createActivity(String name, int colorHex);

  Future<void> updateRecordEmoji(
    int idRecord,
    String emoji,
  );
}
