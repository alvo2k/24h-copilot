import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:scaled_app/scaled_app.dart';
import 'package:screen_retriever/screen_retriever.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'core/common/bloc/theame_cubit.dart';
import 'core/utils/constants.dart';
import 'features/activities/domain/usecases/activities_usecases.dart';
import 'internal/application.dart';
import 'internal/injectable.dart';

part 'internal/main_functions.dart';

void main() {
  runZonedGuarded(
    () async {
      ScaledWidgetsFlutterBinding.ensureInitialized(
        scaleFactor: (deviceSize) {
          const double widthOfDesign = 360;
          return deviceSize.width / widthOfDesign;
        },
      );

      _scaleFactor();

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
