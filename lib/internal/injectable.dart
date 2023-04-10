import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../core/common/data/datasources/drift_db.dart';
import '../features/firebase/data/datasources/sync_local_datasource.dart';
import 'injectable.config.dart';

final sl = GetIt.instance;

@InjectableInit()
void initDependencyInjection() {
  sl.registerLazySingleton<SyncLocalDataSource>(() => ActivityDatabase());
  sl.init();
}
