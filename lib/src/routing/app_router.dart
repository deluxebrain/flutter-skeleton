// private navigators
import 'package:flutter/material.dart';
import 'package:flutterskeleton/src/features/home/presentation/home_details_screen.dart';
import 'package:flutterskeleton/src/features/home/presentation/home_screen.dart';
import 'package:flutterskeleton/src/features/settings/presentation/settings_screen.dart';
import 'package:flutterskeleton/src/routing/scaffold_with_nested_navigation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _counterNavigatorKey = GlobalKey<NavigatorState>(debugLabel: "counter");
final _settingsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: "settings");

enum AppRoute {
  counter,
  counterDetails,
  settings,
}

@riverpod
GoRouter goRouter(GoRouterRef ref) {
  return GoRouter(
      initialLocation: '/counter',
      navigatorKey: _rootNavigatorKey,
      debugLogDiagnostics: true,
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return ScaffoldWithNestedNavigation(
              navigationShell: navigationShell,
            );
          },
          branches: [
            StatefulShellBranch(
              navigatorKey: _counterNavigatorKey,
              routes: [
                GoRoute(
                  path: '/counter',
                  name: AppRoute.counter.name,
                  pageBuilder: (context, state) => const NoTransitionPage(
                    child: HomeScreen(),
                  ),
                  routes: [
                    GoRoute(
                      path: 'details',
                      name: AppRoute.counterDetails.name,
                      builder: (context, state) => const HomeDetailsScreen(),
                    ),
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: _settingsNavigatorKey,
              routes: [
                GoRoute(
                  path: '/settings',
                  name: AppRoute.settings.name,
                  pageBuilder: (context, state) => const NoTransitionPage(
                    child: SettingsScreen(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ]);
}
