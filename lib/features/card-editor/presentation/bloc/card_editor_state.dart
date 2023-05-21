part of 'card_editor_bloc.dart';

abstract class CardEditorState extends Equatable {
  const CardEditorState();

  @override
  List<Object> get props => [];
}

class CardEditorStateInitial extends CardEditorState {}

class CardEditorStateLoading extends CardEditorState {}

class CardEditorStateLoaded extends CardEditorState {
  const CardEditorStateLoaded(this.activitiesSettings);

  final List<ActivitySettings> activitiesSettings;

  @override
  List<Object> get props => [activitiesSettings];
}

class CardEditorStateFailure extends CardEditorState {
  const CardEditorStateFailure(this.message);

  final String message;
}
