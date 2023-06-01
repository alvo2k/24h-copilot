part of 'dashboard_bloc.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}

// TODO: refactor to use SealedBloc
class DashboardInitial extends DashboardState {
  const DashboardInitial(this.firstRecordDate);

  final Future<DateTime?> firstRecordDate;
}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  const DashboardLoaded(this.data);

  final PieChartData? data;
}

class DashboardFailure extends DashboardState {
  const DashboardFailure(this.message);

  final String message;
}
