part of 'card_editor_bloc.dart';

abstract class CardEditorEvent extends Equatable {
  const CardEditorEvent();

  @override
  List<Object> get props => [];
}

class LoadActivitiesSettings extends CardEditorEvent {}

class UpdateActivitiesSettings extends CardEditorEvent {
  final String activityName;
  final String? newActivityName;
  final Color? newColor;
  final List<String>? tags;
  final int? newGoal;

  const UpdateActivitiesSettings({
    required this.activityName,
    this.newActivityName,
    this.newColor,
    this.tags,
    this.newGoal,
  });

  @override
  List<Object> get props => [
        activityName,
        newActivityName ?? '',
        newColor ?? 0,
        tags ?? '',
        newGoal ?? 0,
      ];
}
