import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/common/activity_settings.dart';
import '../../../../core/error/return_types.dart';
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

        final activities = await loadActivitiesUsecase(
          LoadActivitiesParams(event.forTheDay),
        );

        activities.listen((day) => add(_NewActivityDayFromStream(day)));

        final recomendedActivities = recommendedActivitiesUsecase();
        recomendedActivities.listen(
          (recomendedActivities) => add(
            _NewRecomendedActivitiesFromStream(recomendedActivities),
          ),
        );
      },
    );

    on<SwitchActivity>(
      (event, emit) async {
        final result = await switchActivityUsecase(
            SwitchActivitiesParams(event.nextActivityName));
        result.fold(
          (l) => emit(Failure(state.pageState, type: l.type)),
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
          (l) => emit(Failure(state.pageState, type: l.type)),
          (r) => null,
        );
      },
    );

    on<EditName>(
      (event, emit) async {
        final result =
            await editNameUsecase(EditNameParams(event.recordId, event.name));
        result.fold(
          (l) => emit(Failure(state.pageState, type: l.type)),
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
          (l) => emit(Failure(state.pageState, type: l.type)),
          (r) => null,
        );
      },
    );

    on<_NewRecomendedActivitiesFromStream>(
      (event, emit) => emit(
        Loaded(
          state.pageState.copyWith(
            recommendedActivities: event.recomendedActivities,
          ),
        ),
      ),
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
          if (pageState.activityDays[index] == event.activityDay) return;
          
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
    on<_Failure>(
      (event, emit) =>
          emit(Failure(state.pageState, type: FailureType.unknown)),
    );
  }
  @override
  void onError(Object error, StackTrace stackTrace) {
    add(_Failure());
    super.onError(error, stackTrace);
  }
}
