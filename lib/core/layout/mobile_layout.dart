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
                GoRouterState.of(context).fullPath! == '/dashboard',
            child: BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.home),
                  label: AppLocalizations.of(context)!.activities,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.dashboard),
                  label: AppLocalizations.of(context)!.dashboard,
                ),
              ],
              currentIndex: state.bottomNavBarIndex,
              onTap: (int dest) => context
                  .read<NavigationCubit>()
                  .onDestinationSelected(dest),
            ),
          ),
          body: child,
        );
      },
    );
  }
}
