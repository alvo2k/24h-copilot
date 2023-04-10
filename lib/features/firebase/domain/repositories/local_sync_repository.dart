import '../../../../core/common/data/datasources/drift_db.dart';

abstract class LocalSyncRepository {
  Stream<List<DriftActivityModel>> allActivities();
  Stream<List<DriftRecordModel>> allRecords({int from});
}