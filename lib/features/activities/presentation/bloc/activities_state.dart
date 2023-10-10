part of 'activities_bloc.dart';

sealed class ActivitiesState extends Equatable {}

class Initial extends ActivitiesState {
  @override
  List<Object> get props => [];
}

class Failure extends ActivitiesState {
  Failure(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class Loading extends ActivitiesState {
  @override
  List<Object?> get props => [];
}

class Loaded extends ActivitiesState {
  Loaded(this.days);

  final List<ActivityDay> days;

  @override
  List<Object?> get props => [days];
}
