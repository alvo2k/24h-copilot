import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/activity_settings.dart';
import '../../../../core/error/return_types.dart';
import '../../domain/usecases/load_activities_settings_usecase.dart';
import '../../domain/usecases/update_activity_settings_usecase.dart';

part 'card_editor_event.dart';
part 'card_editor_state.dart';

class CardEditorBloc extends Bloc<CardEditorEvent, CardEditorState> {
  CardEditorBloc(this.loadUsecase, this.updateUsecase)
      : super(CardEditorStateInitial()) {
    on<CardEditorEvent>((event, emit) async {
      List<ActivitySettings> currentActivities = [];
      if (event is LoadActivitiesSettings) {
        emit(CardEditorStateLoading());
        await loadUsecase(LoadActivitiesSettingsParams()).then(
          (result) => result.fold(
            (l) => emit(CardEditorStateFailure(l.type)),
            (r) {
              currentActivities = r;
              emit(CardEditorStateLoaded(currentActivities));
            },
          ),
        );
      } else if (event is UpdateActivitiesSettings) {
        emit(CardEditorStateLoading());
        final updateResult = await updateUsecase(UpdateActivitySettingsParams(
          activityName: event.activityName,
          newActivityName: event.newActivityName,
          newColor: event.newColor,
          newGoal: event.newGoal,
          tags: event.tags,
        ));

        await updateResult.fold(
          (l) {
            emit(CardEditorStateFailure(l.type));
            emit(CardEditorStateLoaded(currentActivities));
          },
          (r) async {
            await loadUsecase(LoadActivitiesSettingsParams()).then(
              (result) => result.fold(
                (l) => emit(CardEditorStateFailure(l.type)),
                (r) => emit(CardEditorStateLoaded(r)),
              ),
            );
          },
        );
      }
    });
  }

  final LoadActivitiesSettingsUsecase loadUsecase;
  final UpdateActivitySettingsUsecase updateUsecase;
}
