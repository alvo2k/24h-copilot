part of 'activities_bloc.dart';

sealed class ActivitiesState extends Equatable {
  final PageState pageState;

  const ActivitiesState(this.pageState);
}

class Initial extends ActivitiesState {
  Initial() : super(PageState.initial());

  @override
  List<Object> get props => [];
}

class Failure extends ActivitiesState {
  const Failure(super.pageState, {required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}

class Loading extends ActivitiesState {
  const Loading(super.pageState);

  @override
  List<Object?> get props => [];
}

class Loaded extends ActivitiesState {
  const Loaded(super.pageState);

  @override
  List<Object?> get props => [];
}

class PageState {
  final List<ActivitySettings> recommendedActivities;
  final List<ActivityDay> activityDays;

  PageState({required this.recommendedActivities, required this.activityDays});

  factory PageState.initial() => PageState(
        recommendedActivities: [],
        activityDays: [],
      );
  PageState copyWith({
    List<ActivitySettings>? recommendedActivities,
    List<ActivityDay>? activityDays,
  }) => PageState(
      recommendedActivities:
          recommendedActivities ?? this.recommendedActivities,
      activityDays: activityDays ?? this.activityDays,
    );
}
