part of 'activities_bloc.dart';

abstract class ActivitiesEvent extends Equatable {}

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

