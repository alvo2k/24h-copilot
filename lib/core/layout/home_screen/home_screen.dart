import 'package:flutter/material.dart';

import 'home_screen_desktop.dart';
import 'home_screen_mobile.dart';
import 'home_screen_tablet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static String path = '/';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 630) {
          return const HomeScreenMobile();
        } else if (constraints.maxWidth < 1135) {
          return const HomeScreenTablet();
        } else {
          return const HomeScreenDesktop();
        }
      },
    );
  }
}
