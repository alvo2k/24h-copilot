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

class InsertActivity extends Equatable {
  const InsertActivity({
    required this.name,
    required this.startTime,
    this.endTime,
  });

  final DateTime? endTime;
  final String name;
  final DateTime startTime;

  @override
  List<Object?> get props => [endTime, name, startTime];
}

class ActivitiesEvent extends Union5Impl<LoadActivities, SwitchActivity,
    AddEmoji, EditName, InsertActivity> {
  ActivitiesEvent._(
      Union5<LoadActivities, SwitchActivity, AddEmoji, EditName, InsertActivity>
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

  factory ActivitiesEvent.insertActivity({
    required String name,
    required DateTime startTime,
    DateTime? endTime,
  }) =>
      ActivitiesEvent._(unions.fifth(
          InsertActivity(endTime: endTime, name: name, startTime: startTime)));

  factory ActivitiesEvent.loadActivities(DateTime forTheDay) =>
      ActivitiesEvent._(
        unions.first(LoadActivities(forTheDay)),
      );

  factory ActivitiesEvent.switchActivity(String nextActivityName) =>
      ActivitiesEvent._(
        unions.second(SwitchActivity(nextActivityName)),
      );

  static const unions = Quintet<LoadActivities, SwitchActivity, AddEmoji,
      EditName, InsertActivity>();
}
