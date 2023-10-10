import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'core/utils/constants.dart';
import 'internal/application.dart';
import 'internal/injectable.dart';

void main() {
  runZonedGuarded(() async {
    initDependencyInjection();
    WidgetsFlutterBinding.ensureInitialized();
    await Hive.initFlutter(Constants.appFolderName);
    
    FlutterError.onError = (FlutterErrorDetails details) async {
      FlutterError.presentError(details);
      await Sentry.captureException(
        details,
        stackTrace: details.stack,
      );
      if (kReleaseMode) exit(1);
    };
    await SentryFlutter.init(
      (options) {
        options.dsn = const String.fromEnvironment('SENTRY_DSN');
        // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
        // We recommend adjusting this value in production.
        options.tracesSampleRate = 1.0;
      },
      appRunner: () => runApp(const CopilotApp()),
    );
  }, (Object error, StackTrace stack) async {
    await Sentry.captureException(
      error,
      stackTrace: stack,
    );

    if (kDebugMode) {
      print(stack);
      print(error);
    }
    exit(1);
  });
}
