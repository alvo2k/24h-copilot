import 'package:copilot/core/utils/constants.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../common/bloc/navigation_cubit.dart';
import 'desktop_layout.dart';
import 'mobile_layout.dart';
import 'tablet_layout.dart';

class LayoutWrapper extends StatelessWidget {
  const LayoutWrapper({required this.child, super.key});

  final StatefulNavigationShell child;

  @override
  Widget build(BuildContext context) {
    debugPrint(GoRouterState.of(context).uri.toString());

    return LayoutBuilder(
      builder: (context, constraints) {
        context.read<NavigationCubit>().onResize(constraints);

        if (constraints.maxWidth < Constants.mobileWidth) {
          return MobileLayout(child: child);
        } else if (constraints.maxWidth < Constants.tabletWidth) {
          return TabletLayout(child: child);
        } else {
          return DesktopLayout(child: child);
        }
      },
    );
  }
}
