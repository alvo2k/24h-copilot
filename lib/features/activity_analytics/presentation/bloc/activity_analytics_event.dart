part of 'activity_analytics_bloc.dart';

sealed class ActivityAnalyticsEvent extends Equatable {}

final class _Exception extends ActivityAnalyticsEvent {
  @override
  List<Object?> get props => [];
}

final class LoadActivityAnalytics extends ActivityAnalyticsEvent {
  final String activityName;

  LoadActivityAnalytics(this.activityName);

  @override
  List<Object?> get props => [activityName];
}
