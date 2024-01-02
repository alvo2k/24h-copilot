part of 'history_bloc.dart';

sealed class HistoryState extends Equatable {
  const HistoryState();
}

final class HistoryInitial extends HistoryState {
  const HistoryInitial();

  @override
  List<Object> get props => [];
}

final class HistoryLoading extends HistoryState {
  @override
  List<Object> get props => [];
}

final class HistoryLoaded extends HistoryState {
  const HistoryLoaded(this.data);

  final PieChartData data;

  @override
  List<Object> get props => [data];
}

final class HistoryLoadedNoData extends HistoryState {
  const HistoryLoadedNoData();

  @override
  List<Object> get props => [];
}

final class HistoryFailure extends HistoryState {
  const HistoryFailure(this.type);

  final FailureType type;

  @override
  List<Object> get props => [type];
}
