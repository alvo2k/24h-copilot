import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../features/activities/presentation/pages/activities_page.dart';
import '../../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/card-editor/presentation/pages/activities_settings_page.dart';
import '../../features/card-editor/presentation/pages/activity_settings_page.dart';
import '../common/activity_settings.dart';
import '../common/widgets/navigation_rail.dart';
import '../common/widgets/paddingless_vertical_divider.dart';

class DesktopLayout extends StatelessWidget {
  const DesktopLayout({super.key, required this.child});

  final StatefulNavigationShell child;

  @override
  Widget build(BuildContext context) {
    final currentPath = GoRouterState.of(context).uri.toString();
    return Scaffold(
      body: Row(
        children: [
          const NavigatorRail(),
          const PaddinglessVerticalDivider(),
          if (currentPath == '/') ...[
            Expanded(child: child),
            const PaddinglessVerticalDivider(),
            const Expanded(child: DashboardPage()),
          ] else if (currentPath == '/dashboard') ...[
            const Expanded(child: ActivitiesPage()),
            const PaddinglessVerticalDivider(),
            Expanded(child: child),
          ] else if (currentPath.startsWith('/card_editor')) ...[
            const Expanded(child: ActivitiesSettingsPage()),
            if (GoRouterState.of(context).extra is ActivitySettings) ...[
              const PaddinglessVerticalDivider(),
              Expanded(
                child: ActivitySettingsPage(
                  key: ValueKey(
                    GoRouterState.of(context).extra as ActivitySettings,
                  ),
                  activity: GoRouterState.of(context).extra as ActivitySettings,
                ),
              ),
            ],
          ]
        ],
      ),
    );
  }
}
