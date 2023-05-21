part of 'card_editor_bloc.dart';

abstract class CardEditorEvent extends Equatable {
  const CardEditorEvent();

  @override
  List<Object> get props => [];
}

class LoadActivitiesSettings extends CardEditorEvent {}

class UpdateActivitiesSettings extends CardEditorEvent {
  const UpdateActivitiesSettings({
    required this.activityName,
    required this.newActivityName,
    required this.newColor,
    this.tags,
    this.newGoal,
  });

  final String activityName;
  final String newActivityName;
  final Color newColor;
  final int? newGoal;
  final List<String>? tags;

  @override
  List<Object> get props => [
        activityName,
        newActivityName,
        newColor,
        tags ?? '',
        newGoal ?? 0,
      ];
}
