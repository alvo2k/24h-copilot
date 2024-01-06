import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../pages/activities_page.dart';

class LazyLoadingIndicator extends StatelessWidget {
  const LazyLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ActivityScrollController.of(context).controller;
    return VisibilityDetector(
      key: const ValueKey('activity_loading_indicator'),
      child: const CircularProgressIndicator(),
      onVisibilityChanged: (info) {
        if (info.visibleFraction != 0) controller.position.notifyListeners();
      },
    );
  }
}
