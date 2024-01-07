part of 'card_editor_bloc.dart';

sealed class CardEditorEvent extends Equatable {
  const CardEditorEvent();

  @override
  List<Object> get props => [];
}

final class LoadActivitiesSettings extends CardEditorEvent {}

final class SaveChanges extends CardEditorEvent {
  final void Function() onSuccess;

  const SaveChanges({required this.onSuccess});
}
final class ActivitySelected extends CardEditorEvent {
  final ActivitySettings activity;

  const ActivitySelected(this.activity);
}

final class UpdateField extends CardEditorEvent {
  final String? activityName;
  final Color? color;
  final int? goal;
  final List<String>? tags;

  const UpdateField({
    this.activityName,
    this.color,
    this.goal,
    this.tags,
  });
}
