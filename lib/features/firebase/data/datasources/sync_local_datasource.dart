import '../../../../core/common/data/datasources/drift_db.dart';

abstract class SyncLocalDataSource {
  Stream<List<DriftActivityModel>> watchAllActivities();
  Stream<List<DriftRecordModel>> watchAllRecords({int from});
}