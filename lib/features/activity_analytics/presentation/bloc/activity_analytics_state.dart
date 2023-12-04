part of 'activity_analytics_bloc.dart';

class ActivityAnalyticsState extends Equatable {
  const ActivityAnalyticsState._({
    required this.status,
    this.data,
    this.failure,
  });

  const ActivityAnalyticsState.initial()
      : this._(status: ActivityAnalyticsStatus.initial);

  final ActivityAnalyticsStatus status;
  final FailureType? failure;

  final HeatMapData? data;

  @override
  List<Object?> get props => [status, data, failure];

  ActivityAnalyticsState copyWith({
    ActivityAnalyticsStatus? status,
    HeatMapData? data,
    FailureType? failure,
  }) =>
      ActivityAnalyticsState._(
        status: status ?? this.status,
        data: data ?? this.data,
        failure: failure,
      );
}

enum ActivityAnalyticsStatus { initial, loading, loaded, failure }
