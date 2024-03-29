part of 'activities_bloc.dart';

abstract class ActivitiesEvent extends Equatable {}

class _Failure extends ActivitiesEvent {
  @override
  List<Object?> get props => [];
}

class LoadActivities extends ActivitiesEvent {
  LoadActivities(this.forTheDay);

  final DateTime forTheDay;

  @override
  List<Object> get props => [forTheDay];
}

class SwitchActivity extends ActivitiesEvent {
  SwitchActivity(this.nextActivityName);

  final String nextActivityName;

  @override
  List<Object> get props => [nextActivityName];
}

class AddEmoji extends ActivitiesEvent {
  AddEmoji(this.recordId, this.emoji);

  final String emoji;
  final int recordId;

  @override
  List<Object> get props => [recordId, emoji];
}

class EditName extends ActivitiesEvent {
  EditName(this.name, this.recordId);

  final String name;
  final int recordId;

  @override
  List<Object> get props => [name, recordId];
}

class EditRecords extends ActivitiesEvent {
  EditRecords({
    required this.name,
    this.fixedTime,
    this.selectedTime,
    required this.toChange,
  });

  final DateTime? fixedTime;
  final String name;
  final DateTime? selectedTime;
  final Activity toChange;

  @override
  List<Object?> get props => [fixedTime, name, selectedTime, toChange];
}

class _NewRecomendedActivitiesFromStream extends ActivitiesEvent {
  final List<ActivitySettings> recomendedActivities;

  _NewRecomendedActivitiesFromStream(this.recomendedActivities);

  @override
  List<Object?> get props => [recomendedActivities];
}

class _NewActivityDayFromStream extends ActivitiesEvent {
  _NewActivityDayFromStream(this.activityDay);

  final ActivityDay activityDay;

  @override
  List<Object> get props => [activityDay];
}
