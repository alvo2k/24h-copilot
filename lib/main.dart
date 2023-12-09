import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:copilot/features/activities/domain/usecases/activities_usecases.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:scaled_app/scaled_app.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'core/common/bloc/theame_cubit.dart';
import 'core/utils/constants.dart';
import 'internal/application.dart';
import 'internal/injectable.dart';

part 'internal/main_functions.dart';

void main() {
  runZonedGuarded(
    () async {
      ScaledWidgetsFlutterBinding.ensureInitialized(
        scaleFactor: (deviceSize) {
          if (Platform.isAndroid || Platform.isIOS) return 1;
          // TODO add to settings
          return 1.5;
        },
      );

      await Hive.initFlutter(Constants.appFolderName);

      initDependencyInjection();

      _setupSwitchActivitiesFromNotification();

      FlutterError.onError = _flutterError;

      await SentryFlutter.init(
        _sentryOptionsConfiguration,
        appRunner: () async {
          final themeCubit = ThemeCubit();
          await themeCubit.loadSavedTheme();
          runApp(CopilotApp(themeCubit: themeCubit));
        },
      );
    },
    _zoneError,
  );
}
