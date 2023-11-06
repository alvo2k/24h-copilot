part of 'dashboard_bloc.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();
}

class DashboardLoad extends DashboardEvent {
  const DashboardLoad(this.from, this.to, [this.search]);

  final DateTime from;
  final String? search;
  final DateTime to;
  
  @override
  List<Object?> get props => [from, search, to];
}

class LoadInitialData extends DashboardEvent {

  @override
  List<Object?> get props => [];
}

class _NewDashboardDataFromStream extends DashboardEvent {
  final PieChartData? pieData;

  const _NewDashboardDataFromStream(this.pieData);

  @override
  List<Object> get props => [pieData ?? 0];
}
