import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/activities/presentation/pages/activities_page.dart';
import '../features/activity_analytics/presentation/pages/activity_analytics_page.dart';
import '../features/backup/presentation/pages/backup_page.dart';
import '../features/card-editor/presentation/pages/activities_settings_page.dart';
import '../features/card-editor/presentation/pages/activity_settings_page.dart';
import '../features/history/presentation/pages/history_page.dart';
import 'common/activity_settings.dart';
import 'common/widgets/fade_transition_page.dart';
import 'layout/layout_wrapper.dart';

final _rootKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: _rootKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      parentNavigatorKey: _rootKey,
      path: '/backup',
      name: 'backup',
      pageBuilder: (context, state) => FadeTransitionPage(
        child: const BackupPage(),
      ),
      onExit: BackupPage.onExit,
    ),
    ShellRoute(
      builder: (context, state, child) => LayoutWrapper(child: child),
      routes: [
        GoRoute(
          path: '/',
          name: '/',
          pageBuilder: (context, state) => FadeTransitionLayoutPage(
            context,
            leftPane: const ActivitiesPage(),
            rightPane: const HistoryPage(),
          ),
          routes: [
            GoRoute(
              path: 'history',
              name: 'history',
              pageBuilder: (context, state) => FadeTransitionLayoutPage(
                context,
                leftPane: const ActivitiesPage(),
                rightPane: const HistoryPage(),
                leftIsMain: false,
              ),
              routes: [
                GoRoute(
                  path: 'activity_analytics/:activity_name',
                  name: 'activity_analytics',
                  pageBuilder: (context, state) => FadeTransitionPage(
                    child: ActivityAnalyticsPage(
                      state.pathParameters['activity_name']!,
                    ),
                  ),
                )
              ],
            ),
            GoRoute(
              path: 'card_editor',
              name: 'card_editor',
              pageBuilder: (context, state) => FadeTransitionLayoutPage(
                context,
                leftPane: const ActivitiesSettingsPage(),
              ),
              routes: [
                GoRoute(
                  path: ':name',
                  pageBuilder: (context, state) => FadeTransitionLayoutPage(
                    context,
                    leftIsMain: false,
                    leftPane: const ActivitiesSettingsPage(),
                    rightPane: ActivitySettingsPage(
                      key: ValueKey(state.extra as ActivitySettings),
                      activity: state.extra as ActivitySettings,
                    ),
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
