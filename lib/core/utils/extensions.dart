import 'dart:math';

import 'package:flutter/material.dart';

extension RandomColor on Color {
  static Color get generate =>
      Colors.primaries[Random().nextInt(Colors.primaries.length)];
}

extension ThemeExt on ThemeData {
  Color get cardColorGoalReached => brightness == Brightness.light
      ? const Color.fromRGBO(193, 232, 197, 1)
      : Colors.green[900]!;
}

extension DateTimeExt on DateTime {
  DateTime fromMinutes(int minutes) => add(Duration(minutes: minutes));
}
