import 'package:equatable/equatable.dart';
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

    int loadedAmmount = 0;
    const loadAmmount = 30;

    void changeActivity(Activity newActivity) {
      try {
        // add endTime to prev activity
        final prevActivity =
            loadedActivities.first.activitiesInThisDay.last as ActivityModel;
        final prevActivityWithEndTime =
            prevActivity.changeEndTime(newActivity.startTime);

        loadedActivities.first.activitiesInThisDay.last =
            prevActivityWithEndTime;
      } on StateError {
        // first activity ever
      }
      if (loadedActivities.isEmpty) {
        final now = DateTime.now();
        loadedActivities
            // ignore: prefer_const_literals_to_create_immutables
            .add(ActivityDay([], DateTime(now.year, now.month, now.day)));
      }
      // add activity at the end of the day
      loadedActivities.first.activitiesInThisDay.add(newActivity);
    }

    on<ActivitiesEvent>((event, emit) async {
      await event.join(
        (loadActivities) async {
          emit(ActivitiesState.loading());
          final result = await loadActivitiesUsecase(
            LoadActivitiesParams(
              ammount: loadAmmount,
              skip: loadedAmmount,
            ),
          );
          result.fold(
            (l) => emit(ActivitiesState.failure(l.prop['message'])),
            (r) {
              if (r.isEmpty) {
                loadedActivities
                    .add(ActivityDay(const [], loadedActivities.last.date));
              } else {
                int ammountLoaded = 0;
                for (final day in r) {
                  ammountLoaded += day.activitiesInThisDay.length;
                }
                loadedAmmount += ammountLoaded;
                loadedActivities.addAll(r);
              }
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
              late DateTime editedDate;
              if (editRecords.fixedTime != null) {
                editedDate = editRecords.fixedTime!;
              } else if (editRecords.selectedTime != null) {
                editedDate = editRecords.selectedTime!;
              } else {
                editedDate = editRecords.toChange!.startTime;
              }
              editedDate =
                  DateTime(editedDate.year, editedDate.month, editedDate.day);
              // final load =
              //     await loadActivitiesUsecase(LoadActivitiesParams(editedDate));
              // load.fold(
              //   (l) => ActivitiesState.failure(l.prop['message']),
              //   (r) {
              //     var activitiesInThisDay = ActivityDay(r, editedDate);

              //     final index = loadedActivities
              //         .indexWhere((day) => day.date == editedDate);
              //     loadedActivities.insert(index, activitiesInThisDay);
              //     loadedActivities.removeAt(index + 1);
              //     emit(ActivitiesState.loaded(loadedActivities));
              //   },
              // );
            },
          );
        },
      );
    });
  }
}
