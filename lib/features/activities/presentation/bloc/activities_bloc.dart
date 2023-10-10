import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';

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
  }) : super(Initial()) {
    on<LoadActivities>(
      (event, emit) async {
        emit(Loading());
        final stream = await loadActivitiesUsecase(
          LoadActivitiesParams(event.forTheDay),
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

        emit(Loaded(loadedActivities));
      },
    );

    on<SwitchActivity>(
      (event, emit) async {
        final result = await switchActivityUsecase(
            SwitchActivitiesParams(event.nextActivityName));
        result.fold(
          (l) => emit(Failure(l.prop['message'])),
          // [loadActivities] handler sets up listeners, that updates
          // corresponding [day] and ActivityListView observes this change
          (r) => null,
        );
      },
    );

    on<AddEmoji>(
      (event, emit) async {
        final result =
            await addEmojiUsecase(AddEmojiParams(event.recordId, event.emoji));
        result.fold(
          (l) => emit(Failure(l.prop['message'])),
          (r) => null,
        );
      },
    );

    on<EditName>(
      (event, emit) async {
        final result =
            await editNameUsecase(EditNameParams(event.recordId, event.name));
        result.fold(
          (l) => emit(Failure(l.prop['message'])),
          (r) {
            // TODO edit name functional
          },
        );
      },
    );

    on<EditRecords>(
      (event, emit) async {
        final edit = await editRecordsUsecase(EditRecordsParams(
          name: event.name,
          fixedTime: event.fixedTime,
          selectedTime: event.selectedTime,
          toChange: event.toChange,
        ));
        edit.fold(
          (l) => emit(Failure(l.prop['message'])),
          (r) => null,
        );
      },
    );
  }
}
