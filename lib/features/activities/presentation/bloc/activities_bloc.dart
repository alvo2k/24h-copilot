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
    List<Activity> loadedActivities = [];

    on<ActivitiesEvent>((event, emit) async {
      await event.join(
        (loadActivities) async {
          emit(ActivitiesState.loading());
          final result = await loadActivitiesUsecase(
              LoadActivitiesParams(DateTime(loadActivities.forTheDay.year,
                  loadActivities.forTheDay.month, loadActivities.forTheDay.day)));
          result.fold(
            (l) => emit(ActivitiesState.failure(l.prop['message'])),
            (r) {
              loadedActivities.addAll(r);
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
            (r) {
              loadedActivities.add(r);
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
              loadedActivities.add(r);
              emit(ActivitiesState.loaded(loadedActivities));
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
            (l) => emit(ActivitiesState.failure(l.prop['message'])),
            (r) {
              loadedActivities.add(r);
              emit(ActivitiesState.loaded(loadedActivities));
            },
          );
        },
      );
    });
  }
}
