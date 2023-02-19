import 'package:awesome_notifications/awesome_notifications.dart';

import '../../../../internal/application.dart';

class NotificationController {
  static const inputActivityChannelKey = 'input_activity_channel';

  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    final nextActivity = receivedAction.buttonKeyInput;
    if (nextActivity.isNotEmpty) {
      // SwitchActivitiesUsecase(sl())(SwitchActivitiesParams(nextActivity));
      CopilotApp.navigatorKey.currentState?.pushNamedAndRemoveUntil(
        '/',
        (route) => (route.settings.name != '/') || route.isFirst,
        arguments: nextActivity,
      );
    }
  }
}
