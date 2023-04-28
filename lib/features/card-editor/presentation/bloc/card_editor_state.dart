part of 'card_editor_bloc.dart';

abstract class CardEditorState extends Equatable {
  const CardEditorState();

  @override
  List<Object> get props => [];
}

class CardEditorStateInitial extends CardEditorState {}

class CardEditorStateLoading extends CardEditorState {}

class CardEditorStateLoaded extends CardEditorState {
  final List<ActivitySettings> activitiesSettings;

  const CardEditorStateLoaded(this.activitiesSettings);

  @override
  List<Object> get props => [activitiesSettings];
}

class CardEditorStateFailure extends CardEditorState {
  final String message;

  const CardEditorStateFailure(this.message);
}
