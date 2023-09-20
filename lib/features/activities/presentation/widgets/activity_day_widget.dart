import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/activity_day.dart';
import '../bloc/edit_mode_cubit.dart';
import 'activity_list_tile.dart';
import 'edit_mode_separator.dart';

class ActivityDayWidget extends StatelessWidget {
  const ActivityDayWidget(this.activities, {super.key});

  final ActivityDay activities;

  List<Widget> activityTiles(bool editMode) {
    List<Widget> activityList = [];

    for (int i = 0; i < activities.activitiesInThisDay.length; i++) {
      var activity = activities.activitiesInThisDay[i];
      if (editMode) {
        activityList.add(EditModeSeparator(
          activity,
          activities.date,
          addBefore: true,
        ));
      }
      activityList.add(ActivityListTile(activity));
      if (editMode) {
        activityList.add(EditModeSeparator(
          activity,
          activities.date,
          addBefore: false,
        ));
      }
      try {
        final endTimeText = activity.endTime.toString().substring(11, 16);
        if (i != activities.activitiesInThisDay.length - 1) {
          // if activity isnt last in the day
          // dont print endTime for the last activity
          activityList.add(
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 16,
                  ),
                  child: Text(endTimeText),
                ),
              ],
            ),
          );
        }
      } on RangeError catch (_) {}
    }
    return activityList;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditModeCubit, bool>(
      key: const PageStorageKey('activityDay'),
      builder: (context, editMode) => Column(
        children: activityTiles(editMode),
      ),
    );
  }
}
