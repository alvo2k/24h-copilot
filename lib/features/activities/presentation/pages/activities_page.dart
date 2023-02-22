import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/common/widgets/common_drawer.dart';
import '../../domain/entities/activity_day.dart';
import '../bloc/activities_bloc.dart';
import '../widgets/activity_list_view.dart';
import '../widgets/new_activity_field.dart';
import '../bloc/notification_controller.dart';

class ActivitiesPage extends StatefulWidget {
  const ActivitiesPage({super.key});

  @override
  State<ActivitiesPage> createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends State<ActivitiesPage> {
  final controller = ScrollController();

  @override
  void initState() {    
    controller.addListener(loadMoreDays);

    super.initState();
  }

  void createNotification() {
    final newActivityPrompt = AppLocalizations.of(context)!.newActivityPrompt;
    final newActivityPromptShort = AppLocalizations.of(context)!.newActivityPromptShort;
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
        var activitiesBlock = BlocProvider.of<ActivitiesBloc>(context);

        late DateTime dateToLoad;
        late ActivityDay lastLoadedActivityDay;
        activitiesBlock.state.join(
          (_) => null,
          (_) => null,
          (loaded) {
            lastLoadedActivityDay = loaded.days.last;
            dateToLoad =
                lastLoadedActivityDay.date.subtract(const Duration(days: 1));
          },
          (_) => null,
        );

        if (lastLoadedActivityDay.activitiesInThisDay.isEmpty) {
          // all activities in DB allready loaded
          controller.removeListener(loadMoreDays);
          return;
        }
        activitiesBlock.add(ActivitiesEvent.loadActivities(dateToLoad));
      }
    }

  @override
  Widget build(BuildContext context) {
    createNotification();

    final newActivityFromNotification =
        ModalRoute.of(context)?.settings.arguments as String?;
    if (newActivityFromNotification != null &&
        newActivityFromNotification.isNotEmpty) {
      BlocProvider.of<ActivitiesBloc>(context).add(
          ActivitiesEvent.switchActivity(newActivityFromNotification.trim()));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        foregroundColor: const Color.fromARGB(255, 0, 0, 0),
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.activities),
        // actions: [
        //   IconButton(
        //     icon: SvgPicture.asset('assets/icons/edit_mode.svg'),
        //     tooltip: 'Edit mode',
        //     onPressed: () {},
        //   ),
        // ],
      ),
      drawer: const CommonDrawer(),
      body: Column(
        children: [
          Expanded(child: ActivityListView(controller)),
          NewActivityField(controller),
        ],
      ),
    );
  }  
}
