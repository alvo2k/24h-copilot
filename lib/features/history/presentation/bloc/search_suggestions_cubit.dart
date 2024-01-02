import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/pie_chart_data_usecase.dart';

class SearchSuggestionsCubit extends Cubit<List<String>> {
  SearchSuggestionsCubit(this.usecase) : super([]);

  PieChartDataUsecase usecase;

  Future<void> search(String prompt) async {
    emit(await usecase.getSuggestions(prompt));
  }
}
