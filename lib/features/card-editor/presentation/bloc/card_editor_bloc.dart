import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/activity_settings.dart';
import '../../domain/usecases/load_activities_settings_usecase.dart';
import '../../domain/usecases/update_activity_settings_usecase.dart';

part 'card_editor_event.dart';
part 'card_editor_state.dart';

class CardEditorBloc extends Bloc<CardEditorEvent, CardEditorState> {
  final LoadActivitiesSettingsUsecase loadUsecase;
  final UpdateActivitySettingsUsecase updateUsecase;
  CardEditorBloc(this.loadUsecase, this.updateUsecase)
      : super(CardEditorStateInitial()) {
    on<CardEditorEvent>((event, emit) async {
      if (event is LoadActivitiesSettings) {
        emit(CardEditorStateLoading());
        await loadUsecase(LoadActivitiesSettingsParams()).then(
          (result) => result.fold(
            (l) => emit(CardEditorStateFailure(l.prop['message'])),
            (r) => emit(CardEditorStateLoaded(r)),
          ),
        );
      } else if (event is UpdateActivitiesSettings) {
        emit(CardEditorStateLoading());
        await updateUsecase(UpdateActivitySettingsParams(
          activityName: event.activityName,
          newActivityName: event.newActivityName,
          newColor: event.newColor,
          newGoal: event.newGoal,
          tags: event.tags,
        )).then(
          (result) => result.fold(
            (l) => emit(CardEditorStateFailure(l.prop['message'])),
            (r) => emit(CardEditorStateUpdated(r)),
          ),
        );
      }
    });
  }
}
