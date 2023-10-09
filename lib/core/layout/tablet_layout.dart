import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../common/bloc/navigation_cubit.dart';
import '../common/widgets/navigation_rail.dart';

class TabletLayout extends StatelessWidget {
  const TabletLayout({super.key, required this.child});

  final StatefulNavigationShell child;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) => Scaffold(
        body: Row(
          children: [
            const NavigatorRail(),
            const VerticalDivider(),
            Expanded(
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
