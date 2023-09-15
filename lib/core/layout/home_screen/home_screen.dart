import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/bloc/home_screen_cubit.dart';
import 'home_screen_desktop.dart';
import 'home_screen_mobile.dart';
import 'home_screen_tablet.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static String path = '/';

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 630) {
          context.read<HomeScreenCubit>().isMobileLayout(true);
          context.read<HomeScreenCubit>().showAnalyticsDestination();
          return const HomeScreenMobile();
        } else if (constraints.maxWidth < 1135) {
          context.read<HomeScreenCubit>().isMobileLayout(false);
          context.read<HomeScreenCubit>().showAnalyticsDestination();
          return const HomeScreenTablet();
        } else {
          context.read<HomeScreenCubit>().isMobileLayout(false);
          context.read<HomeScreenCubit>().hideAnalyticsDestination();
          return const HomeScreenDesktop();
        }
      },
    );
  }
}
