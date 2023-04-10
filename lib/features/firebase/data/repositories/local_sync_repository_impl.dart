import 'package:injectable/injectable.dart';

import '../../../../core/common/data/datasources/drift_db.dart';
import '../../domain/repositories/local_sync_repository.dart';
import '../datasources/sync_local_datasource.dart';

@LazySingleton(as: LocalSyncRepository)
class LocalSyncRepositoryImpl extends LocalSyncRepository {
  // manualy injected in /lib/internal/injectable.dart
  LocalSyncRepositoryImpl(this.datasource);

  final SyncLocalDataSource datasource;

  @override
  Stream<List<DriftActivityModel>> allActivities() {
    return datasource.watchAllActivities();
  }

  @override
  Stream<List<DriftRecordModel>> allRecords({int? from}) {
    return datasource.watchAllRecords();
  }
}
