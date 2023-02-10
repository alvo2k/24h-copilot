import 'package:flutter_bloc/flutter_bloc.dart';

enum LanguageState { english, russian }

class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit() : super(LanguageState.english);

  void changeLanguage(LanguageState language) {
    emit(language);
  }
}