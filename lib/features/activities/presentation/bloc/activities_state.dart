part of 'activities_bloc.dart';

class ActivitiesState extends Union4Impl<Initial, Loading, Loaded, Failure> {
  ActivitiesState._(Union4<Initial, Loading, Loaded, Failure> union)
      : super(union);

  factory ActivitiesState.failure(String message) =>
      ActivitiesState._(unions.fourth(Failure(message)));

  factory ActivitiesState.initial() => ActivitiesState._(unions.first(Initial()));

  factory ActivitiesState.loaded(List<Activity> activities) =>
      ActivitiesState._(unions.third(Loaded(activities)));

  factory ActivitiesState.loading() =>
      ActivitiesState._(unions.second(Loading()));

  static const unions = Quartet<Initial, Loading, Loaded, Failure>();
}

class Initial extends Equatable {
  @override
  List<Object> get props => [];
}

class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class Loading extends Equatable {
  @override
  List<Object?> get props => [];
}

class Loaded extends Equatable {
  const Loaded(this.activities);

  final List<Activity> activities;

  @override
  List<Object?> get props => [activities];
}
