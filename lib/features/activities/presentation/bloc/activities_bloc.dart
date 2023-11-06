import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/common/activity_settings.dart';
import '../../../../core/utils/constants.dart';
import '../../domain/entities/activity.dart';
import '../../domain/entities/activity_day.dart';
import '../../domain/usecases/activities_usecases.dart';
import '../../domain/usecases/recommended_activities_usecase.dart';

part 'activities_event.dart';
part 'activities_state.dart';

@injectable
class ActivitiesBloc extends Bloc<ActivitiesEvent, ActivitiesState> {
  final pageStorageBucket = PageStorageBucket();

  ActivitiesBloc({
    required LoadActivitiesUsecase loadActivitiesUsecase,
    required SwitchActivitiesUsecase switchActivityUsecase,
    required AddEmojiUsecase addEmojiUsecase,
    required EditNameUsecase editNameUsecase,
    required EditRecordsUsecase editRecordsUsecase,
    required RecommendedActivitiesUsecase recommendedActivitiesUsecase,
  }) : super(Initial()) {
    on<LoadActivities>(
      (event, emit) async {
        emit(Loading(state.pageState));
        final stream = await loadActivitiesUsecase(
          LoadActivitiesParams(event.forTheDay),
        );

        stream.listen((day) => add(_NewActivityDayFromStream(day)));

        final recomendedActivities = await recommendedActivitiesUsecase();

        recommendedActivitiesUsecase.changes().listen(
              (event) => event != null
                  ? add(_RecomendedActivitiesChanged(activity: event))
                  : null,
            );

        emit(
          Loaded(
            state.pageState.copyWith(
              recommendedActivities: recomendedActivities,
            ),
          ),
        );
      },
    );

    on<SwitchActivity>(
      (event, emit) async {
        final result = await switchActivityUsecase(
            SwitchActivitiesParams(event.nextActivityName));
        result.fold(
          (l) => emit(Failure(state.pageState, message: l.prop['message'])),
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
          (l) => emit(Failure(state.pageState, message: l.prop['message'])),
          (r) => null,
        );
      },
    );

    on<EditName>(
      (event, emit) async {
        final result =
            await editNameUsecase(EditNameParams(event.recordId, event.name));
        result.fold(
          (l) => emit(Failure(state.pageState, message: l.prop['message'])),
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
          (l) => emit(Failure(state.pageState, message: l.prop['message'])),
          (r) => null,
        );
      },
    );

    on<_RecomendedActivitiesChanged>(
      (event, emit) {
        final recAct = state.pageState.recommendedActivities;

        if (!recAct.contains(event.activity) &&
            recAct.length < Constants.activitiesAmmountToRecommend) {
          emit(
            Loaded(
              state.pageState.copyWith(
                recommendedActivities: [...recAct, event.activity],
              ),
            ),
          );
        }
      },
    );

    on<_NewActivityDayFromStream>(
      (event, emit) {
        final pageState = state.pageState;
        final index = pageState.activityDays
            .indexWhere((element) => element.date == event.activityDay.date);
        if (index == -1) {
          final updatedState = [...pageState.activityDays, event.activityDay];
          emit(
            Loaded(
              pageState.copyWith(
                activityDays: updatedState,
              ),
            ),
          );
        } else {
          final updatedState = [...pageState.activityDays];
          updatedState[index] = event.activityDay;
          emit(
            Loaded(
              pageState.copyWith(activityDays: updatedState),
            ),
          );
        }
      },
    );
  }
}
