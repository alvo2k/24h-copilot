import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:sealed_flutter_bloc/sealed_flutter_bloc.dart';

import '../../../../core/common/data/models/activity_model.dart';
import '../../domain/entities/activity.dart';
import '../../domain/entities/activity_day.dart';
import '../../domain/usecases/activities_usecases.dart';

part 'activities_event.dart';
part 'activities_state.dart';

@injectable
class ActivitiesBloc extends Bloc<ActivitiesEvent, ActivitiesState> {
  ActivitiesBloc({
    required LoadActivitiesUsecase loadActivitiesUsecase,
    required SwitchActivitiesUsecase switchActivityUsecase,
    required AddEmojiUsecase addEmojiUsecase,
    required EditNameUsecase editNameUsecase,
    required EditRecordsUsecase editRecordsUsecase,
  }) : super(ActivitiesState.initial()) {
    List<ActivityDay> loadedActivities = [];

    void changeActivity(Activity newActivity) {
      try {
        // add endTime to prev activity
        final prevActivity =
            loadedActivities.first.activitiesInThisDay.first as ActivityModel;
        final prevActivityWithEndTime =
            prevActivity.changeEndTime(newActivity.startTime);

        loadedActivities.first.activitiesInThisDay.first =
            prevActivityWithEndTime;
      } on StateError {
        // first activity ever
      }
      if (loadedActivities.isEmpty) {
        final now = DateTime.now();
        loadedActivities
            // ignore: prefer_const_literals_to_create_immutables
            .add(ActivityDay([], DateUtils.dateOnly(now)));
        // empty day at the end indicates that there are no more activities to load
        loadedActivities.add(
          ActivityDay(
            const [],
            loadedActivities.last.date,
          ),
        );
      }
      // add activity at the start (end) of the day
      final newDay = [
        newActivity,
        ...loadedActivities.first.activitiesInThisDay
      ];
      loadedActivities.first.activitiesInThisDay = newDay;
    }

    on<ActivitiesEvent>((event, emit) async {
      await event.join(
        (loadActivities) async {
          emit(ActivitiesState.loading());
          final result = await loadActivitiesUsecase(
            LoadActivitiesParams(loadActivities.forTheDay),
          );
          result.fold(
            (l) => emit(ActivitiesState.failure(l.prop['message'])),
            (r) {
              loadedActivities.add(r);
              emit(ActivitiesState.loaded(loadedActivities));
            },
          );
        },
        (switchActivity) async {
          emit(ActivitiesState.loading());
          final result = await switchActivityUsecase(
              SwitchActivitiesParams(switchActivity.nextActivityName));
          result.fold(
            (l) => emit(ActivitiesState.failure(l.prop['message'])),
            (newActivity) async {
              changeActivity(newActivity);
              emit(ActivitiesState.loaded(loadedActivities));
            },
          );
        },
        (addEmoji) async {
          final result = await addEmojiUsecase(
              AddEmojiParams(addEmoji.recordId, addEmoji.emoji));
          result.fold(
            (l) => emit(ActivitiesState.failure(l.prop['message'])),
            (r) => null,
          );
        },
        (editName) async {
          emit(ActivitiesState.loading());
          final result = await editNameUsecase(
              EditNameParams(editName.recordId, editName.name));
          result.fold(
            (l) => emit(ActivitiesState.failure(l.prop['message'])),
            (r) {
              // TODO edit name functional
            },
          );
        },
        (editRecords) async {
          emit(ActivitiesState.loading());
          final edit = await editRecordsUsecase(EditRecordsParams(
            name: editRecords.name,
            fixedTime: editRecords.fixedTime,
            selectedTime: editRecords.selectedTime,
            toChange: editRecords.toChange,
          ));
          await edit.fold<Future>(
            (l) =>
                Future(() => emit(ActivitiesState.failure(l.prop['message']))),
            (r) async {
              final DateTime editedDate = DateUtils.dateOnly(r.startTime);

              final result =
                  await loadActivitiesUsecase(LoadActivitiesParams(editedDate));
              result.fold(
                  (l) => emit(ActivitiesState.failure(l.prop['message'])), (r) {
                for (int i = 0; i < loadedActivities.length; i++) {
                  if (loadedActivities[i].date == editedDate) {
                    loadedActivities[i] = r;
                    emit(ActivitiesState.loaded(loadedActivities));
                    return;
                  }
                }
              });
            },
          );
        },
      );
    });
  }
}
