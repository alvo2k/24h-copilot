import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../domain/entities/pie_chart_data.dart';
import '../../domain/usecases/pie_chart_data_usecase.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  var data = Rx<PieChartData?>(null);

  DashboardBloc(this.usecase)
      : super(DashboardInitial(usecase.firstRecordDate())) {
    on<DashboardLoad>((event, emit) async {
      emit(DashboardLoading());
      final stream = await usecase(PieChartDataParams(
        from: event.from,
        to: event.to,
        search: event.search,
      ));

      stream.listen((pieData) {
        data.trigger(pieData);
      });

      emit(DashboardLoaded(data.value));
    });
  }

  PieChartDataUsecase usecase;
}
