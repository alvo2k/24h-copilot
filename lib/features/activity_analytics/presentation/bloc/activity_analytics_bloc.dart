import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/return_types.dart';
import '../../domain/view.dart';

part 'activity_analytics_event.dart';
part 'activity_analytics_state.dart';

class ActivityAnalyticsBloc
    extends Bloc<ActivityAnalyticsEvent, ActivityAnalyticsState> {
  final ActivityAnalyticsUseCase _usecase;

  ActivityAnalyticsBloc(this._usecase)
      : super(const ActivityAnalyticsState.initial()) {
    on<LoadActivityAnalytics>(_loadActivityAnalytics);
  }

  void _loadActivityAnalytics(
    LoadActivityAnalytics event,
    Emitter<ActivityAnalyticsState> emit,
  ) async {
    emit(state.copyWith(status: ActivityAnalyticsStatus.loading));

    final result = await _usecase(event.activityName);

    result.fold(
      (l) => emit(
        state.copyWith(
          status: ActivityAnalyticsStatus.failure,
          failure: l.type,
        ),
      ),
      (r) => emit(
        state.copyWith(
          status: ActivityAnalyticsStatus.loaded,
          data: r,
        ),
      ),
    );
  }
}
