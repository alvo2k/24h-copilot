import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/activity_settings.dart';
import '../../../../core/error/return_types.dart';
import '../../domain/entities/validation_errors.dart';
import '../../domain/usecases/load_activities_settings_usecase.dart';
import '../../domain/usecases/update_activity_settings_usecase.dart';

part 'card_editor_event.dart';
part 'card_editor_state.dart';

class CardEditorBloc extends Bloc<CardEditorEvent, CardEditorState> {
  CardEditorBloc(this.loadUsecase, this.updateUsecase)
      : super(const CardEditorState()) {
    on<LoadActivitiesSettings>(_load);
    on<SaveChanges>(_save);
    on<UpdateField>(_update);
    on<ActivitySelected>(_activitySelected);
  }

  void _load(LoadActivitiesSettings event, Emitter emit) async {
    final result = await loadUsecase(LoadActivitiesSettingsParams());
    result.fold(
      (l) => emit(
        state.copyWith(
          type: l.type,
        ),
      ),
      (r) => emit(
        state.copyWith(
          activitiesSettings: r,
        ),
      ),
    );
  }

  void _save(SaveChanges event, Emitter emit) async {
    final validationResult = updateUsecase.validate(
      state.editedActivitySettings!.name,
      state.editedActivitySettings!.tags ?? [],
    );

    if (validationResult != null) {
      emit(
        state.copyWith(
          validationErrors: validationResult,
        ),
      );
      return;
    }

    final updateResult = await updateUsecase(
      UpdateActivitySettingsParams(
        activityName: state.initialActivitySettings!.name,
        newActivityName: state.editedActivitySettings!.name,
        newColor: state.editedActivitySettings!.color,
        newGoal: state.editedActivitySettings!.goal,
        tags: state.editedActivitySettings!.tags,
      ),
    );
    updateResult.fold(
      (l) => emit(
        state.copyWith(
          type: l.type,
        ),
      ),
      (r) {
        emit(
          state.copyWith(
            initialActivitySettings: r.copyWith(),
          ),
        );
        event.onSuccess();
      },
    );
  }

  void _update(UpdateField event, Emitter emit) {
    final updated = state.editedActivitySettings!.copyWith(
      name: event.activityName,
      color: event.color,
      goal: event.goal,
      tags: event.tags,
    );

    emit(
      state.copyWith(
        editedActivitySettings: updated,
      ),
    );
  }

  void _activitySelected(ActivitySelected event, Emitter emit) => emit(
        state.copyWith(
          editedActivitySettings: event.activity,
          initialActivitySettings: event.activity,
        ),
      );

  final LoadActivitiesSettingsUsecase loadUsecase;
  final UpdateActivitySettingsUsecase updateUsecase;
}
