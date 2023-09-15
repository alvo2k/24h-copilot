import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../bloc/activities_bloc.dart';
import '../bloc/notification_controller.dart';
import '../widgets/activity_list_view.dart';
import '../widgets/new_activity_field.dart';

class ActivitiesPage extends StatefulWidget {
  const ActivitiesPage({super.key});

  @override
  State<ActivitiesPage> createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends State<ActivitiesPage> {
  final controller = ScrollController();

  @override
  void didChangeDependencies() {
    final newActivityFromNotification =
        ModalRoute.of(context)?.settings.arguments as String?;
    if (newActivityFromNotification != null &&
        newActivityFromNotification.trim().isNotEmpty) {
      BlocProvider.of<ActivitiesBloc>(context).add(
          ActivitiesEvent.switchActivity(newActivityFromNotification.trim()));
    }

    createNotification();

    super.didChangeDependencies();
  }

  @override
  void initState() {
    controller.addListener(loadMoreDays);

    super.initState();
  }

  void createNotification() {
    final newActivityPrompt = AppLocalizations.of(context)!.newActivityPrompt;
    final newActivityPromptShort =
        AppLocalizations.of(context)!.newActivityPromptShort;
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
    );

    AwesomeNotifications().isNotificationAllowed().then((isAllowed) async {
      if (!isAllowed) {
        // TODO ask user to allow notifications and save the result
        isAllowed =
            await AwesomeNotifications().requestPermissionToSendNotifications();
      }
      if (isAllowed) {
        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: 1,
            channelKey: NotificationController.inputActivityChannelKey,
            title: newActivityPrompt,
            autoDismissible: false,
            fullScreenIntent: true,
          ),
          actionButtons: [
            NotificationActionButton(
              key: 'INPUT_BUTTON',
              label: newActivityPromptShort,
              requireInputText: true,
            ),
          ],
        );
      }
    });
  }

  void loadMoreDays() {
    // load next day
    if (controller.position.extentAfter < 20 &&
        controller.position.outOfRange == false) {
      var activitiesBloc = BlocProvider.of<ActivitiesBloc>(context);

      final lastLoadedActivityDay = activitiesBloc.loadedActivities.last;
      final dateToLoad =
          lastLoadedActivityDay.date.subtract(const Duration(days: 1));

      if (lastLoadedActivityDay.activitiesInThisDay.isEmpty) {
        // all activities in DB allready loaded
        controller.removeListener(loadMoreDays);
        return;
      }
      activitiesBloc.add(ActivitiesEvent.loadActivities(dateToLoad));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: ActivityListView(controller)),
        NewActivityField(controller),
      ],
    );
  }
}
