import 'package:equatable/equatable.dart';

import 'activity.dart';

class ActivityDay {
  ActivityDay(
    this.activitiesInThisDay,
    this.date,
  );

  List<Activity> activitiesInThisDay;
  final DateTime date;
}
