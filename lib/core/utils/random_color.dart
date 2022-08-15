import 'dart:math';

import 'package:flutter/material.dart';

abstract class RandomColor {
  static Color get generate =>
      Colors.primaries[Random().nextInt(Colors.primaries.length)];
}
