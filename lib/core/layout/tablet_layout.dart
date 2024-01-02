import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../common/bloc/navigation_cubit.dart';
import '../common/widgets/navigation_rail.dart';
import '../common/widgets/paddingless_vertical_divider.dart';

class TabletLayout extends StatelessWidget {
  const TabletLayout({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) => Scaffold(
        body: Row(
          children: [
            const NavigatorRail(),
            const PaddinglessVerticalDivider(),
            Expanded(
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
