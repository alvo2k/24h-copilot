import 'dart:async';
import 'dart:io';

import 'package:copilot/internal/application.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      // TODO: error tracking service
      if (kReleaseMode) exit(1);
    };
    runApp(const CopilotApp());
  }, (Object error, StackTrace stack) {
    // TODO: error tracking service
    exit(1);
  });
}