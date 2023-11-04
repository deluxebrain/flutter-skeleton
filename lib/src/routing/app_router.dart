// private navigators
import 'package:flutter/material.dart';
import 'package:flutterskeleton/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:flutterskeleton/src/features/authentication/presentation/custom_profile_screen.dart';
import 'package:flutterskeleton/src/features/authentication/presentation/custom_sign_in_screen.dart';
import 'package:flutterskeleton/src/features/home/presentation/home_details_screen.dart';
import 'package:flutterskeleton/src/features/home/presentation/home_screen.dart';
import 'package:flutterskeleton/src/features/onboarding/data/onboarding_repository.dart';
import 'package:flutterskeleton/src/features/onboarding/presentation/onboarding_screen.dart';
import 'package:flutterskeleton/src/routing/go_router_refresh_stream.dart';
import 'package:flutterskeleton/src/routing/scaffold_with_nested_navigation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: "home");
final _settingsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: "settings");

enum AppRoute {
  onboarding,
  signIn,
  counter,
  counterDetails,
  profile,
}

@riverpod
GoRouter goRouter(GoRouterRef ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final onboardingRepository = ref.watch(onboardingRepositoryProvider);

  return GoRouter(
      initialLocation: '/signIn',
      navigatorKey: _rootNavigatorKey,
      debugLogDiagnostics: true,
      redirect: (context, state) {
        final didCompleteOnboarding = onboardingRepository.onboardingComplete();
        final path = state.uri.path;
        if (!didCompleteOnboarding) {
          if (path != '/onboarding') {
            return '/onboarding';
          }
        }
        final isLoggedIn = authRepository.currentUser != null;
        if (isLoggedIn) {
          if (path.startsWith('/signIn')) {
            return '/home';
          }
        } else {
          if (!path.startsWith('/onboarding')) {
            return '/signIn';
          }
        }

        // no redirect
        return null;
      },
      refreshListenable:
          GoRouterRefreshStream(authRepository.authStateChanges()),
      routes: [
        GoRoute(
          path: '/onboarding',
          name: AppRoute.onboarding.name,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: OnboardingScreen(),
          ),
        ),
        GoRoute(
          path: '/signIn',
          name: AppRoute.signIn.name,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: CustomSignInScreen(),
          ),
        ),
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return ScaffoldWithNestedNavigation(
              navigationShell: navigationShell,
            );
          },
          branches: [
            StatefulShellBranch(
              navigatorKey: _homeNavigatorKey,
              routes: [
                GoRoute(
                  path: '/home',
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
                  path: '/account',
                  name: AppRoute.profile.name,
                  pageBuilder: (context, state) => const NoTransitionPage(
                    child: CustomProfileScreen(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ]);
}
