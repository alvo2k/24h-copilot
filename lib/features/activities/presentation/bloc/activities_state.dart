part of 'activities_bloc.dart';

abstract class ActivitiesState extends Equatable {
  const ActivitiesState();  

  @override
  List<Object> get props => [];
}
class ActivitiesInitial extends ActivitiesState {}
