part of 'activities_bloc.dart';

sealed class ActivitiesState extends Equatable {
  final PageState pageState;

  const ActivitiesState(this.pageState);

  @override
  List<Object> get props => [pageState];
}

class Initial extends ActivitiesState {
  Initial() : super(PageState.initial());
}

class Failure extends ActivitiesState {
  const Failure(super.pageState, {required this.type});

  final FailureType type;

  @override
  List<Object> get props => [pageState, type];
}

class Loading extends ActivitiesState {
  const Loading(super.pageState);
}

class Loaded extends ActivitiesState {
  const Loaded(super.pageState);
}

class PageState extends Equatable {
  final List<ActivitySettings> recommendedActivities;
  final List<ActivityDay> activityDays;

  const PageState({
    required this.recommendedActivities,
    required this.activityDays,
  });

  bool get isEmpty =>
      activityDays.length == 1 && activityDays[0].activitiesInThisDay.isEmpty;

  factory PageState.initial() => const PageState(
        recommendedActivities: [],
        activityDays: [],
      );

  PageState copyWith({
    List<ActivitySettings>? recommendedActivities,
    List<ActivityDay>? activityDays,
  }) =>
      PageState(
        recommendedActivities:
            recommendedActivities ?? this.recommendedActivities,
        activityDays: activityDays ?? this.activityDays,
      );

  @override
  List<Object?> get props => [recommendedActivities, activityDays];
}
