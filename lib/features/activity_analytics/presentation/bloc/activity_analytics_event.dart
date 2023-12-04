part of 'activity_analytics_bloc.dart';

sealed class ActivityAnalyticsEvent extends Equatable {}

final class LoadActivityAnalytics extends ActivityAnalyticsEvent {
  final String activityName;

  LoadActivityAnalytics(this.activityName);
  
  @override
  List<Object?> get props => [activityName];
}
