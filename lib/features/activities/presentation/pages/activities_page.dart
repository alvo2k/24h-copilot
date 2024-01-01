import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/common/widgets/activity_search_bar.dart';
import '../../../../core/common/widgets/common_drawer.dart';
import '../../../../core/notification_controller.dart';
import '../../../../core/utils/constants.dart';
import '../../../../internal/injectable.dart';
import '../bloc/activities_bloc.dart';
import '../widgets/activity_list_view.dart';
import '../widgets/new_activity_field.dart';
import '../widgets/recommended_activities.dart';

class ActivitiesPage extends StatefulWidget {
  const ActivitiesPage({super.key});

  @override
  State<ActivitiesPage> createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends State<ActivitiesPage> {
  final controller = ScrollController();
  bool canPop = false;

  @override
  void initState() {
    controller.addListener(loadMoreDays);

    super.initState();
  }

  @override
  void dispose() {
    controller.removeListener(loadMoreDays);
    controller.dispose();

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    sl<NotificationController>().createNotification(context);
  }

  void loadMoreDays() {
    // load next day
    if (controller.position.extentAfter < 20 &&
        controller.position.outOfRange == false) {
      final activitiesBloc = BlocProvider.of<ActivitiesBloc>(context);

      final lastLoadedActivityDay =
          activitiesBloc.state.pageState.activityDays.last;
      final dateToLoad =
          lastLoadedActivityDay.date.subtract(const Duration(days: 1));

      if (lastLoadedActivityDay.activitiesInThisDay.isEmpty) {
        // all activities in DB allready loaded
        controller.removeListener(loadMoreDays);
        return;
      }
      activitiesBloc.add(LoadActivities(dateToLoad));
    }
  }

  void confirmPop() {
    canPop = true;
    setState(() {});

    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.confirmExit),
        duration: const Duration(seconds: 2),
      ),
    );
    Future.delayed(const Duration(seconds: 2), () {
      canPop = false;
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop,
      onPopInvoked: (didPop) => didPop ? null : confirmPop(),
      child: Scaffold(
        appBar: ActivitySearchBar(
          showEditMode: true,
          title: AppLocalizations.of(context)!.activities,
        ),
        drawer: MediaQuery.of(context).size.width <= Constants.mobileWidth
            ? const CommonDrawer()
            : null,
        body: ActivityScrollController(
          controller: controller,
          child: Column(
            children: [
              const Expanded(child: ActivityListView()),
              RecommendedActivities(child: const NewActivityField()),
            ],
          ),
        ),
      ),
    );
  }
}

class ActivityScrollController extends InheritedWidget {
  const ActivityScrollController({
    super.key,
    required super.child,
    required this.controller,
  });

  final ScrollController controller;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;

  static ActivityScrollController of(BuildContext context) {
    return context.findAncestorWidgetOfExactType<ActivityScrollController>()!;
  }

  void animateToNewActivity() {
    if (controller.hasClients) {
      controller.animateTo(
        controller.position.minScrollExtent,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeOut,
      );
    }
  }
}
