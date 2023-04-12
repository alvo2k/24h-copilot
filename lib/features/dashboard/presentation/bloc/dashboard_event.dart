part of 'dashboard_bloc.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class DashboardLoad extends DashboardEvent {
  const DashboardLoad(this.from, this.to);

  final DateTime from;
  final DateTime to;
}