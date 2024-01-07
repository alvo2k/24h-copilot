// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'card_editor_bloc.dart';

class CardEditorState extends Equatable {
  const CardEditorState({
    this.activitiesSettings,
    this.type,
    this.initialActivitySettings,
    this.editedActivitySettings,
    this.validationErrors,
  });

  final List<ActivitySettings>? activitiesSettings;
  final FailureType? type;
  final ValidationErrors? validationErrors;
  final ActivitySettings? initialActivitySettings;
  final ActivitySettings? editedActivitySettings;

  @override
  List<Object> get props => [
        activitiesSettings ?? 0,
        type ?? 0,
        validationErrors ?? 0,
        initialActivitySettings ?? 0,
        editedActivitySettings ?? 0,
      ];

  CardEditorState copyWith({
    List<ActivitySettings>? activitiesSettings,
    FailureType? type,
    ActivitySettings? initialActivitySettings,
    ActivitySettings? editedActivitySettings,
    ValidationErrors? validationErrors,
  }) {
    return CardEditorState(
      activitiesSettings: activitiesSettings ?? this.activitiesSettings,
      type: type,
      initialActivitySettings:
          initialActivitySettings ?? this.initialActivitySettings,
      editedActivitySettings:
          editedActivitySettings ?? this.editedActivitySettings,
      validationErrors: validationErrors,
    );
  }
}
