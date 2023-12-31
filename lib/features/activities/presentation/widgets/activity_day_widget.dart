import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/activity_day.dart';
import '../bloc/edit_mode_cubit.dart';
import 'activity_list_tile.dart';
import 'edit_mode_separator.dart';

class ActivityDayWidget extends StatefulWidget {
  const ActivityDayWidget(this.activities, {super.key});

  final ActivityDay activities;

  @override
  State<ActivityDayWidget> createState() => _ActivityDayWidgetState();
}

class _ActivityDayWidgetState extends State<ActivityDayWidget>
    with TickerProviderStateMixin {
  late final AnimationController separatorController;
  late final Animation<double> opacity;

  @override
  void initState() {
    super.initState();
    separatorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: separatorController,
        curve: Curves.easeInCubic,
      ),
    );
  }

  @override
  void dispose() {
    separatorController.dispose();
    super.dispose();
  }

  List<Widget> activityTiles(bool editMode) {
    List<Widget> activityList = [];

    for (int i = 0; i < widget.activities.activitiesInThisDay.length; i++) {
      final activity = widget.activities.activitiesInThisDay[i];

      activityList.add(
        EditModeSeparator(
          activity,
          widget.activities.date,
          addBefore: true,
          sizeAnimation: separatorController,
          opacityAnimation: opacity,
        ),
      );

      activityList.add(ActivityListTile(activity));

      activityList.add(
        EditModeSeparator(
          activity,
          widget.activities.date,
          addBefore: false,
          sizeAnimation: separatorController,
          opacityAnimation: opacity,
        ),
      );

      if (activity.endTime != null &&
          i != widget.activities.activitiesInThisDay.length - 1) {
        activityList.add(
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16,
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
    return BlocConsumer<EditModeCubit, bool>(
      key: const PageStorageKey('activityDay'),
      listener: (context, state) =>
          state ? separatorController.forward() : separatorController.reverse(),
      builder: (context, editMode) => Column(
        children: activityTiles(editMode),
      ),
    );
  }
}
