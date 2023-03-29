import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../utils/constants.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);

  setTheme(ThemeMode theme) {
    _changeThemeSetting(theme);
    emit(theme);
  }

  loadSavedTheme() async {
    final box = await Hive.openBox(Constants.settingsBoxName);

    String? theme = box.get(Constants.settingsThemeName);
    if (theme == null) return; // default state (ThemeMode.system)
    if (theme == 'system') emit(ThemeMode.system);
    if (theme == 'light') emit(ThemeMode.light);
    if (theme == 'dark') emit(ThemeMode.dark);
  }

  _changeThemeSetting(ThemeMode theme) async {
    final box = await Hive.openBox(Constants.settingsBoxName);

    box.put(Constants.settingsThemeName, theme.name);
  }
}
