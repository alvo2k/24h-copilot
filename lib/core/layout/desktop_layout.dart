import 'package:flutter/material.dart';

import 'tablet_layout.dart';

class DesktopLayout extends StatelessWidget {
  const DesktopLayout({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TabletLayout(child: child);
  }
}
