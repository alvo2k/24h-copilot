import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:sealed_flutter_bloc/sealed_flutter_bloc.dart';

import '../../domain/entities/activity.dart';
import '../../domain/entities/activity_day.dart';
import '../../domain/usecases/activities_usecases.dart';

part 'activities_event.dart';
part 'activities_state.dart';

@injectable
class ActivitiesBloc extends Bloc<ActivitiesEvent, ActivitiesState> {
  final loadedActivities = <ActivityDay>[].obs;
  final pageStorageBucket = PageStorageBucket();

  ActivitiesBloc({
    required LoadActivitiesUsecase loadActivitiesUsecase,
    required SwitchActivitiesUsecase switchActivityUsecase,
    required AddEmojiUsecase addEmojiUsecase,
    required EditNameUsecase editNameUsecase,
    required EditRecordsUsecase editRecordsUsecase,
  }) : super(ActivitiesState.initial()) {
    on<ActivitiesEvent>((event, emit) async {
      await event.join(
        (loadActivities) async {
          emit(ActivitiesState.loading());
          final stream = await loadActivitiesUsecase(
            LoadActivitiesParams(loadActivities.forTheDay),
          );
          stream.listen((day) {
            final index = loadedActivities
                .indexWhere((element) => element.date == day.date);
            if (index == -1) {
              loadedActivities.add(day);
            } else {
              loadedActivities[index] = day;
            }
          });

          emit(ActivitiesState.loaded(loadedActivities));
        },
        (switchActivity) async {
          final result = await switchActivityUsecase(
              SwitchActivitiesParams(switchActivity.nextActivityName));
          result.fold(
            (l) => emit(ActivitiesState.failure(l.prop['message'])),
            // [loadActivities] handler sets up listeners, that updates
            // corresponding [day] and ActivityListView observes this change
            (r) => null,
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
          final edit = await editRecordsUsecase(EditRecordsParams(
            name: editRecords.name,
            fixedTime: editRecords.fixedTime,
            selectedTime: editRecords.selectedTime,
            toChange: editRecords.toChange,
          ));
          edit.fold(
            (l) => emit(ActivitiesState.failure(l.prop['message'])),
            (r) => null,
          );
        },
      );
    });
  }
}
