import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../../../core/error/return_types.dart';
import '../../domain/entities/pie_chart_data.dart';
import '../../domain/usecases/pie_chart_data_usecase.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  late final DateTime? firstActivityDate;

  HistoryBloc(this._usecase) : super(const HistoryInitial()) {
    _usecase.firstRecordDate().then((value) => firstActivityDate = value);
    on<HistoryLoad>((event, emit) async {
      emit(HistoryLoading());
      final stream = await _usecase(PieChartDataParams(
        from: event.from,
        to: event.to,
        search: event.search,
      ));

      stream.handleError((error) {
        debugPrint('Error loading PieChartData: $error');
        Sentry.captureException(error);
      }).listen(
        (pieData) => add(
          _NewHistoryDataFromStream(pieData),
        ),
      );
    });

    on<_NewHistoryDataFromStream>(
      (event, emit) => emit(
        event.pieData != null
            ? HistoryLoaded(event.pieData!)
            : const HistoryLoadedNoData(),
      ),
    );

    on<LoadInitialData>(
      (event, emit) async {
        final initialDates = await _usecase.datesForInitialData();

        add(HistoryLoad(initialDates.from, initialDates.to));
      },
    );

    on<_Exception>(
      (event, emit) => emit(
        const HistoryFailure(FailureType.unknown),
      ),
    );

    add(LoadInitialData());
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    add(_Exception());
    super.onError(error, stackTrace);
  }

  final PieChartDataUsecase _usecase;
}
