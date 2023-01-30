import 'package:equatable/equatable.dart';

import 'activity.dart';

class ActivityDay extends Equatable {
  const ActivityDay(
    this.activitiesInThisDay,
    this.date,
  );

  final List<Activity> activitiesInThisDay;
  final DateTime date;

  @override
  List<Object?> get props => [
        activitiesInThisDay,
        date,
      ];
}
