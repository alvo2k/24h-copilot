import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import '../core/app_router.dart';
import '../core/common/data/datasources/activity_database.dart';
import '../core/common/data/datasources/activity_local_data_source.dart';
import '../features/activity_analytics/data/datasources/activity_analytics_data_source.dart';
import 'injectable.config.dart';

final sl = GetIt.instance;

@InjectableInit()
void initDependencyInjection() {
  sl.init();

  sl.registerSingleton<ActivityAnalyticsDataSource>(sl<ActivityDatabase>());
  sl.registerSingleton<ActivityLocalDataSource>(sl<ActivityDatabase>());
  sl.registerSingleton<GoRouter>(router);
}
