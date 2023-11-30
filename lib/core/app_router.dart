import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import '../features/activities/presentation/pages/activities_page.dart';
import '../features/activity_analytics/presentation/pages/activity_analytics_page.dart';
import '../features/card-editor/presentation/pages/activities_settings_page.dart';
import '../features/card-editor/presentation/pages/activity_settings_page.dart';
import '../features/dashboard/presentation/pages/dashboard_page.dart';
import 'common/activity_settings.dart';
import 'layout/layout_wrapper.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, child) {
        return LayoutWrapper(child: child);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const ActivitiesPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/dashboard',
              builder: (context, state) => const DashboardPage(),
              routes: [
                GoRoute(
                  path: 'activity_analytics',
                  name: 'activity_analytics',
                  builder: (context, state) => ActivityAnalyticsPage(
                    state.extra as String,
                  ),
                )
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/card_editor',
              builder: (context, state) => const ActivitiesSettingsPage(),
              routes: [
                GoRoute(
                  path: ':name',
                  builder: (context, state) => ActivitySettingsPage(
                    key: ValueKey(state.extra as ActivitySettings),
                    activity: state.extra as ActivitySettings,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
