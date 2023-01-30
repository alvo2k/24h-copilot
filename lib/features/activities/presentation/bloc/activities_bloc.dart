import '../../data/models/activity_model.dart';
import '../../domain/entities/activity_day.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:sealed_flutter_bloc/sealed_flutter_bloc.dart';

import '../../domain/entities/activity.dart';
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
    required InsertActivityUsecase insertActivityUsecase,
  }) : super(ActivitiesState.initial()) {
    List<ActivityDay> loadedActivities = [];

    void changeActivity(Activity newActivity) {
      try {
        // add endTime to prev activity
        final prevActivity = loadedActivities.last.activitiesInThisDay.last as ActivityModel;
        final prevActivityWithEndTime = prevActivity.changeEndTime(newActivity.startTime);
        
        loadedActivities.last.activitiesInThisDay.last = prevActivityWithEndTime;
      } on StateError {
        // first activity ever
        DateTime now = DateTime.now();
        loadedActivities.add(ActivityDay(
          [newActivity],
          DateTime(now.year, now.month, now.day),
        ));
        return;
      }
      // add activity at the end of the day
      loadedActivities.last.activitiesInThisDay.add(newActivity);
    }

    on<ActivitiesEvent>((event, emit) async {
      await event.join(
        (loadActivities) async {
          emit(ActivitiesState.loading());
          final result = await loadActivitiesUsecase(
            LoadActivitiesParams(DateTime(
              loadActivities.forTheDay.year,
              loadActivities.forTheDay.month,
              loadActivities.forTheDay.day,
            )),
          );
          result.fold(
            (l) => emit(ActivitiesState.failure(l.prop['message'])),
            (r) {
              //if (r.isNotEmpty) {
                var activitiesInThisDay =
                    ActivityDay(r, loadActivities.forTheDay);

                loadedActivities.add(activitiesInThisDay);
              //}
              emit(ActivitiesState.loaded(loadedActivities));
            },
          );
        },
        (switchActivity) async {
          emit(ActivitiesState.loading());
          final result = await switchActivityUsecase(
              SwitchActivitiesParams(switchActivity.nextActivityName));
          await result.fold<Future<void>>(
            (l) =>
                Future(() => emit(ActivitiesState.failure(l.prop['message']))),
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
        (insertActivity) async {
          emit(ActivitiesState.loading());
          final result = await insertActivityUsecase(InsertActivityParams(
            name: insertActivity.name,
            startTime: insertActivity.startTime,
            endTime: insertActivity.endTime,
          ));
          result.fold(
            (l) =>
                emit(ActivitiesState.failure(l.prop['message'])),
            (r) {
              if (insertActivity.endTime == null) {
                // then new activity is in the end so [switchActivity] logic applies
                changeActivity(r);
              } else {
                // TODO
              }

              emit(ActivitiesState.loaded(loadedActivities));
            },
          );
        },
      );
    });
  }
}
