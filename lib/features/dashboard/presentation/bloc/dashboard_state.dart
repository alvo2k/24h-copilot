part of 'dashboard_bloc.dart';

sealed class DashboardState extends Equatable {
  const DashboardState();
}

class DashboardInitial extends DashboardState {
  const DashboardInitial();

  @override
  List<Object> get props => [];
}

class DashboardLoading extends DashboardState {
  @override
  List<Object> get props => [];
}

class DashboardLoaded extends DashboardState {
  const DashboardLoaded(this.data);

  final PieChartData data;

  @override
  List<Object> get props => [data];
}

class DashboardLoadedNoData extends DashboardState {
  const DashboardLoadedNoData();

  @override
  List<Object> get props => [];
}

class DashboardFailure extends DashboardState {
  const DashboardFailure(this.type);

  final FailureType type;

  @override
  List<Object> get props => [type];
}
