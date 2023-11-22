import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:injectable/injectable.dart';

import '../features/activities/data/repositories/activity_repository_impl.dart';
import '../features/activities/domain/usecases/switch_activities_usecase.dart';
import 'common/data/datasources/activity_database.dart';

@singleton
class NotificationController {
  NotificationController()
      : awesomeNotifications = AwesomeNotifications()
          ..initialize(
            null,
            [
              NotificationChannel(
                channelKey: NotificationController.inputActivityChannelKey,
                channelName: 'New Activity Input',
                channelDescription: 'Enter new activity',
                importance: NotificationImportance.Low,
              ),
            ],
          );

  final AwesomeNotifications awesomeNotifications;

  static const inputActivityChannelKey = 'input_activity_channel';

  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    final nextActivity = receivedAction.buttonKeyInput;

    if (nextActivity.trim().isEmpty) {
      return;
    }

    final switchActivitySendPort = IsolateNameServer.lookupPortByName(
      'switch_activity_from_notification',
    );

    if (switchActivitySendPort != null) {
      //* App is in the background or foreground
      switchActivitySendPort.send(nextActivity.trim());
    } else {
      //* App is terminated

      final usecase = SwitchActivitiesUsecase(
        ActivityRepositoryImpl(
          ActivityDatabase(),
        ),
      );

      await usecase(SwitchActivitiesParams(nextActivity.trim()));
    }
  }

  void createNotification(BuildContext context) {
    final newActivityPrompt = AppLocalizations.of(context)!.newActivityPrompt;
    final newActivityPromptShort =
        AppLocalizations.of(context)!.newActivityPromptShort;

    awesomeNotifications.setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
    );

    awesomeNotifications.isNotificationAllowed().then((isAllowed) async {
      if (!isAllowed) {
        // TODO ask user to allow notifications and save the result
        isAllowed =
            await awesomeNotifications.requestPermissionToSendNotifications();
      }
      if (isAllowed) {
        awesomeNotifications.createNotification(
          content: NotificationContent(
            id: 1,
            locked: true,
            channelKey: NotificationController.inputActivityChannelKey,
            title: newActivityPrompt,
            autoDismissible: false,
            fullScreenIntent: true,
          ),
          actionButtons: [
            NotificationActionButton(
              actionType: ActionType.SilentBackgroundAction,
              key: 'INPUT_BUTTON',
              label: newActivityPromptShort,
              requireInputText: true,
            ),
          ],
        );
      }
    });
  }
}
