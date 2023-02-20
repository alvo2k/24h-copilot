import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);

  static const _settingsBoxName = 'settings';
  static const _settingsThemeName = 'theme';

  setTheme(ThemeMode theme) {
    _changeThemeSetting(theme);
    emit(theme);
  }

  loadSavedTheme() async {
    final box = await Hive.openBox(_settingsBoxName);

    String? theme = box.get(_settingsThemeName);
    if (theme == null) return; // default state (ThemeMode.system)
    if (theme == 'system') emit(ThemeMode.system);
    if (theme == 'light') emit(ThemeMode.light);
    if (theme == 'dark') emit(ThemeMode.dark);
  }

  _changeThemeSetting(ThemeMode theme) async {
    final box = await Hive.openBox(_settingsBoxName);

    box.put(_settingsThemeName, theme.name);
  }
}
