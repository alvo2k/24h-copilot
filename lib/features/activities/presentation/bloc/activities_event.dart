part of 'activities_bloc.dart';

class LoadActivities extends Equatable {
  const LoadActivities(this.forTheDay);

  final DateTime forTheDay;

  @override
  List<Object> get props => [forTheDay];
}

class SwitchActivity extends Equatable {
  const SwitchActivity(this.nextActivityName);

  final String nextActivityName;

  @override
  List<Object> get props => [nextActivityName];
}

class AddEmoji extends Equatable {
  const AddEmoji(this.recordId, this.emoji);

  final String emoji;
  final int recordId;

  @override
  List<Object> get props => [recordId, emoji];
}

class EditName extends Equatable {
  const EditName(this.name, this.recordId);

  final String name;
  final int recordId;

  @override
  List<Object> get props => [name, recordId];
}

class EditRecords extends Equatable {
  const EditRecords({
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

class ActivitiesEvent extends Union5Impl<LoadActivities, SwitchActivity,
    AddEmoji, EditName, EditRecords> {
  ActivitiesEvent._(
      Union5<LoadActivities, SwitchActivity, AddEmoji, EditName, EditRecords>
          union)
      : super(union);

  factory ActivitiesEvent.addEmoji(int recordId, String emoji) =>
      ActivitiesEvent._(
        unions.third(AddEmoji(recordId, emoji)),
      );

  factory ActivitiesEvent.editName(int recordId, String name) =>
      ActivitiesEvent._(
        unions.fourth(EditName(name, recordId)),
      );

  factory ActivitiesEvent.editRecords({
    DateTime? fixedTime,
    required String name,
    DateTime? selectedTime,
    required Activity toChange,
  }) =>
      ActivitiesEvent._(unions.fifth(EditRecords(
        fixedTime: fixedTime,
        name: name,
        selectedTime: selectedTime,
        toChange: toChange,
      )));

  factory ActivitiesEvent.loadActivities(DateTime forTheDay) =>
      ActivitiesEvent._(
        unions.first(LoadActivities(forTheDay)),
      );

  factory ActivitiesEvent.switchActivity(String nextActivityName) =>
      ActivitiesEvent._(
        unions.second(SwitchActivity(nextActivityName)),
      );

  static const unions = Quintet<LoadActivities, SwitchActivity, AddEmoji,
      EditName, EditRecords>();
}
