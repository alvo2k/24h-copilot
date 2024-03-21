import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/activity_settings.dart';
import '../../domain/usecases/pie_chart_data_usecase.dart';

class SearchSuggestionsCubit extends Cubit<SearchSuggestion> {
  SearchSuggestionsCubit(this.usecase) : super(SearchSuggestion());

  PieChartDataUsecase usecase;

  Future<void> search(String prompt) async {
    if (prompt.startsWith('#')) {
      emit(
        SearchSuggestion(
          tags: await usecase.searchTags(prompt),
        ),
      );
    } else {
      emit(
        SearchSuggestion(
          activities: await usecase.searchActivities(prompt),
        ),
      );
    }
  }
}

class SearchSuggestion {
  final List<ActivitySettings> activities;
  final List<String> tags;

  SearchSuggestion({
    this.activities = const [],
    this.tags = const [],
  });
}
