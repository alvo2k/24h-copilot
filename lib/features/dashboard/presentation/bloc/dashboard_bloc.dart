import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../domain/entities/pie_chart_data.dart';
import '../../domain/usecases/pie_chart_data_usecase.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc(this.usecase)
      : super(DashboardInitial(usecase.firstRecordDate())) {
    on<DashboardLoad>((event, emit) async {
      emit(DashboardLoading());
      final stream = await usecase(PieChartDataParams(
        from: event.from,
        to: event.to,
        search: event.search,
      ));

      stream.handleError((error) {
        debugPrint('Error loading PieChartData: $error');
        Sentry.captureException(error);
      }).listen(
        (pieData) => add(
          _NewDashboardDataFromStream(pieData),
        ),
      );
    });

    on<_NewDashboardDataFromStream>(
      (event, emit) => emit(
        event.pieData != null
            ? DashboardLoaded(event.pieData!)
            : const DashboardLoadedNoData(),
      ),
    );

    on<LoadInitialData>(
      (event, emit) async {
        final initialDates = await usecase.datesForInitialData();

        add(DashboardLoad(initialDates.from, initialDates.to));
      },
    );
  }

  PieChartDataUsecase usecase;
}
