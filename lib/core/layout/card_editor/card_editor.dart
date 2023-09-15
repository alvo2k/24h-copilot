import 'package:flutter/material.dart';

import 'card_editor_desktop.dart';
import 'card_editor_mobile.dart';
import 'card_editor_tablet.dart';

class CardEditorScreen extends StatelessWidget {
  const CardEditorScreen({super.key});

  static String path = '/card_editor';

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 630) {
          return const CardEditorMobile();
        } else if (constraints.maxWidth < 1135) {
          return const CardEditorTablet();
        } else {
          return const CardEditorDesktop();
        }
      },
    );
  }
}