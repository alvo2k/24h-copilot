import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          bottomNavigationBar: BottomNavigationBar(
            items: AppNavigationDestination.values
                .map(
                  (destination) => BottomNavigationBarItem(
                    icon: destination.icon,
                    activeIcon: destination.selectedIcon,
                    label: destination.label(context),
                  ),
                )
                .toList(),
            currentIndex: state.destination.index,
            onTap: (dest) =>
                context.read<NavigationCubit>().onDestinationSelected(dest),
          ),
          body: child,
        );
      },
    );
  }
}
