part of 'dashboard_bloc.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();  

  @override
  List<Object> get props => [];
}

// TODO: refactor to use SealedBloc
class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final PieChartData data;

  const DashboardLoaded(this.data);
}

class DashboardFailure extends DashboardState {
  final String message;

  const DashboardFailure(this.message);
}