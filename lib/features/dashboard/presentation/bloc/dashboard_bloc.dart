import '../../domain/usecases/pie_chart_data_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/pie_chart_data.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  PieChartDataUsecase usecase;
  DashboardBloc(this.usecase) : super(DashboardInitial()) {
    on<DashboardLoad>((event, emit) async {
      emit(DashboardLoading());
      final result = await usecase(PieChartDataParams(
        from: event.from,
        to: event.to,
      ));
      result.fold(
        (l) => emit(DashboardFailure(l.prop['message'])),
        (r) => emit(DashboardLoaded(r)),
      );
    });
  }
}
