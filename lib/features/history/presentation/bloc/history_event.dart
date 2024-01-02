part of 'history_bloc.dart';

abstract class HistoryEvent extends Equatable {
  const HistoryEvent();
}

class _Exception extends HistoryEvent {
  @override
  List<Object?> get props => [];
}

class HistoryLoad extends HistoryEvent {
  const HistoryLoad(this.from, this.to, [this.search]);

  final DateTime from;
  final String? search;
  final DateTime to;

  @override
  List<Object?> get props => [from, search, to];
}

class LoadInitialData extends HistoryEvent {
  @override
  List<Object?> get props => [];
}

class _NewHistoryDataFromStream extends HistoryEvent {
  final PieChartData? pieData;

  const _NewHistoryDataFromStream(this.pieData);

  @override
  List<Object> get props => [pieData ?? 0];
}
