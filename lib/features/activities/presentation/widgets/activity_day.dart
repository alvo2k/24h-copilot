import 'package:flutter/material.dart';

import '../../domain/entities/activity_day.dart';
import 'activity_list_tile.dart';

class ActivityDayWidget extends StatelessWidget {
  const ActivityDayWidget(this.activities, {super.key});

  final ActivityDay activities;

  List<Widget> activityTiles() {
    List<Widget> activityList = [];

    for (int i = 0; i < activities.activitiesInThisDay.length; i++) {
      var e = activities.activitiesInThisDay[i];
      activityList.add(ActivityListTile(e));
      try {
        final endTimeText = e.endTime.toString().substring(11, 16);
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
    return Column(
      children: activityTiles(),
    );
  }
}
