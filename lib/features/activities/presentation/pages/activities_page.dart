import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/common/bloc/navigation_cubit.dart';
import '../../../../core/common/widgets/activity_search_bar.dart';
import '../../../../core/common/widgets/common_drawer.dart';
import '../../../../core/notification_controller.dart';
import '../../../../core/utils/constants.dart';
import '../../../../internal/injectable.dart';
import '../bloc/activities_bloc.dart';
import '../bloc/edit_mode_cubit.dart';
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
    return Scaffold(
      appBar: buildSearchAppbar(
        context,
        title: AppLocalizations.of(context)!.activities,
        actionButtons: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/edit_mode.svg',
              alignment: Alignment.bottomRight,
              colorFilter: ColorFilter.mode(
                Theme.of(context).iconTheme.color!,
                BlendMode.srcIn,
              ),
            ),
            tooltip: AppLocalizations.of(context)!.editMode,
            onPressed: () => BlocProvider.of<EditModeCubit>(context).toggle(),
          )
        ],
        onSuggestionTap: (search) =>
            context.read<NavigationCubit>().onSuggestionTap(context, search),
      ),
      drawer: MediaQuery.of(context).size.width <= Constants.mobileWidth
          ? const CommonDrawer()
          : null,
      body: Column(
        children: [
          Expanded(child: ActivityListView(controller)),
          NewActivityField(controller),
        ],
      ),
    );
  }
}
