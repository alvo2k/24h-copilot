import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scaled_app/scaled_app.dart';

import '../common/bloc/navigation_cubit.dart';
import '../utils/constants.dart';
import 'desktop_layout.dart';
import 'mobile_layout.dart';
import 'tablet_layout.dart';

class LayoutWrapper extends StatelessWidget {
  const LayoutWrapper({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).scale(),
      child: LayoutBuilder(
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
      ),
    );
  }
}
