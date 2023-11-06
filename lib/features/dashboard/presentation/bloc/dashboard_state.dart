part of 'dashboard_bloc.dart';

sealed class DashboardState extends Equatable {
  const DashboardState();
}

class DashboardInitial extends DashboardState {
  const DashboardInitial(this.firstRecordDate);

  final Future<DateTime?> firstRecordDate;

  @override
  List<Object> get props => [firstRecordDate];
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
  const DashboardFailure(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
