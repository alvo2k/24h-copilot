import 'dart:async';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'features/activities/presentation/bloc/notification_controller.dart';
import 'internal/application.dart';
import 'internal/injectable.dart';

void main() {
  runZonedGuarded(() async {
    initDependencyInjection();
    WidgetsFlutterBinding.ensureInitialized();
    await Hive.initFlutter();
    AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
            channelKey: NotificationController.inputActivityChannelKey,
            channelName: 'New Activity Input',
            channelDescription: 'Enter new activity',
            importance: NotificationImportance.Low),
      ],
    );
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      // TODO: error tracking service
      if (kReleaseMode) exit(1);
    };
    runApp(const CopilotApp());
  }, (Object error, StackTrace stack) {
    // TODO: error tracking service
    if (kDebugMode) {
      print(stack);
      print(error);
    }
    exit(1);
  });
}
