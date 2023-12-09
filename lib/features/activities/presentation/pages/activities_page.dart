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
      var activitiesBloc = BlocProvider.of<ActivitiesBloc>(context);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ActivitySearchBar(
        showEditMode: true,
        title: AppLocalizations.of(context)!.activities,
      ),
      drawer: MediaQuery.of(context).size.width <= Constants.mobileWidth
          ? const CommonDrawer()
          : null,
      body: Column(
        children: [
          Expanded(child: ActivityListView(controller)),
          RecommendedActivities(child: NewActivityField(controller)),
        ],
      ),
    );
  }
}
