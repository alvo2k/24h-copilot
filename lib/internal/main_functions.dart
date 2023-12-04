part of '../main.dart';

void _flutterError(FlutterErrorDetails details) async {
  FlutterError.presentError(details);
  await Sentry.captureException(
    details,
    stackTrace: details.stack,
  );
  if (kDebugMode) {
    print(details);
  }
}

void _sentryOptionsConfiguration(SentryFlutterOptions options) {
  options.dsn = const String.fromEnvironment('SENTRY_DSN');
  // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
  // We recommend adjusting this value in production.
  options.tracesSampleRate = 1.0;
}

Future<void> _zoneError(Object error, StackTrace st) async {
  await Sentry.captureException(
    error,
    stackTrace: st,
  );

  if (kDebugMode) {
    print(st);
    print(error);
  }
}

void _setupSwitchActivitiesFromNotification() {
  final switchUpdates = ReceivePort();

  Isolate.spawn(_switchActivityFromNotification, switchUpdates.sendPort);

  switchUpdates
      .takeWhile((element) => element is String)
      .cast<String>()
      .listen((newActivityName) {
    sl<SwitchActivitiesUsecase>().call(
      SwitchActivitiesParams(newActivityName),
    );
  });
}

/// Used by [NotificationController] to send strings of new activities
void _switchActivityFromNotification(SendPort sp) async {
  IsolateNameServer.registerPortWithName(
    sp,
    'switch_activity_from_notification',
  );
}
