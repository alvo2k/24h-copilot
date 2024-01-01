import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/activity_day.dart';
import 'activity_list_tile.dart';
import 'edit_mode_separator.dart';

class ActivityDayWidget extends StatelessWidget {
  const ActivityDayWidget(
    this.activities, {
    super.key,
    required this.sizeAnimation,
    required this.opacityAnimation,
  });

  final ActivityDay activities;
  final Animation<double> sizeAnimation;
  final Animation<double> opacityAnimation;

  List<Widget> activityTiles() {
    List<Widget> activityList = [];

    for (int i = 0; i < activities.activitiesInThisDay.length; i++) {
      final activity = activities.activitiesInThisDay[i];

      activityList.add(
        EditModeSeparator(
          activity,
          activities.date,
          addBefore: true,
          sizeAnimation: sizeAnimation,
          opacityAnimation: opacityAnimation,
        ),
      );

      activityList.add(ActivityListTile(activity));

      activityList.add(
        EditModeSeparator(
          activity,
          activities.date,
          addBefore: false,
          sizeAnimation: sizeAnimation,
          opacityAnimation: opacityAnimation,
        ),
      );

      if (activity.endTime != null &&
          i != activities.activitiesInThisDay.length - 1) {
        activityList.add(
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 12,
                ),
                child: Text(DateFormat('HH:mm').format(activity.endTime!)),
              ),
            ],
          ),
        );
      }
    }
    return activityList;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const PageStorageKey('activityDay'),
      children: activityTiles(),
    );
  }
}
