import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../common/bloc/navigation_cubit.dart';
import '../common/widgets/common_drawer.dart';

class MobileLayout extends StatelessWidget {
  const MobileLayout({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) {
        return Scaffold(
          drawer: const CommonDrawer(),
          bottomNavigationBar: Visibility(
            visible: GoRouterState.of(context).fullPath! == '/' ||
                GoRouterState.of(context).fullPath! == '/history',
            child: BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.home_rounded),
                  label: AppLocalizations.of(context)!.activities,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.history_rounded),
                  label: AppLocalizations.of(context)!.history,
                ),
              ],
              currentIndex: state.bottomNavBarIndex,
              onTap: (dest) =>
                  context.read<NavigationCubit>().onDestinationSelected(dest),
            ),
          ),
          body: child,
        );
      },
    );
  }
}
