import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:scaled_app/scaled_app.dart';

import '../../utils/constants.dart';
import 'paddingless_vertical_divider.dart';

class FadeTransitionPage extends CustomTransitionPage {
  FadeTransitionPage({required super.child})
      : super(
          transitionsBuilder: (
            _,
            animation,
            __,
            child,
          ) {
            return FadeTransition(
              opacity: CurveTween(curve: Curves.easeOut).animate(animation),
              child: child,
            );
          },
        );
}

class FadeTransitionLayoutPage extends FadeTransitionPage {
  FadeTransitionLayoutPage._({required super.child});

  factory FadeTransitionLayoutPage(
    BuildContext context, {
    required Widget leftPane,
    Widget? rightPane,
    bool leftIsMain = true,
  }) {
    final width = MediaQuery.of(context).scale().size.width;
    if (width < Constants.mobileWidth) {
      return FadeTransitionLayoutPage._(
          child: leftIsMain || rightPane == null ? leftPane : rightPane);
    } else if (width < Constants.tabletWidth) {
      return FadeTransitionLayoutPage._(
          child: leftIsMain || rightPane == null ? leftPane : rightPane);
    } else {
      return FadeTransitionLayoutPage._(
        child: Row(
          children: [
            Expanded(child: leftPane),
            const PaddinglessVerticalDivider(),
            Expanded(child: rightPane ?? const Scaffold()),
          ],
        ),
      );
    }
  }
}
