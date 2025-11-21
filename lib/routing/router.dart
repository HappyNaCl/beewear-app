import 'package:beewear_app/providers/app_startup_provider.dart';
import 'package:beewear_app/routing/routes.dart';
import 'package:beewear_app/ui/authorized/widgets/authorized_screen.dart';
import 'package:beewear_app/ui/home/widgets/home_screen.dart';
import 'package:beewear_app/ui/landing/widgets/landing_screen.dart';
import 'package:beewear_app/ui/login/widgets/login_screen.dart';
import 'package:beewear_app/ui/register/widgets/register_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final appStartupState = ref.watch(appStartupProvider);

  return GoRouter(
    initialLocation: Routes.landing,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      debugPrint('🔄 [ROUTER] Redirect check started');
      debugPrint('🔄 [ROUTER] Current location: ${state.matchedLocation}');

      return appStartupState.when(
        data: (authState) {
          debugPrint('✅ [ROUTER] AppStartup state: $authState');

          final isGoingToHome = state.matchedLocation == Routes.home;
          final isGoingToAuthorized =
              state.matchedLocation == Routes.authorized;
          final isAuthenticated = authState == AuthState.authenticated;
          final isPublicRoute =
              state.matchedLocation == Routes.landing ||
              state.matchedLocation == Routes.login ||
              state.matchedLocation == Routes.register;

          debugPrint('🔄 [ROUTER] isAuthenticated: $isAuthenticated');
          debugPrint('🔄 [ROUTER] isGoingToHome: $isGoingToHome');
          debugPrint('🔄 [ROUTER] isPublicRoute: $isPublicRoute');

          if (isAuthenticated && isPublicRoute) {
            debugPrint(
              '🏠 [ROUTER] Authenticated user on public route -> Redirecting to /home',
            );
            return Routes.home;
          }

          // If user is authenticated and not going to a protected route, redirect to home
          if (isAuthenticated && !isGoingToHome && !isGoingToAuthorized) {
            debugPrint(
              '🏠 [ROUTER] Authenticated user on unknown route -> Redirecting to /home',
            );
            return Routes.home;
          }

          // If user is not authenticated and trying to access protected routes, redirect to landing
          if (!isAuthenticated && (isGoingToHome || isGoingToAuthorized)) {
            debugPrint(
              '🚫 [ROUTER] Unauthenticated user on protected route -> Redirecting to /landing',
            );
            return Routes.landing;
          }

          // No redirect needed
          debugPrint('✅ [ROUTER] No redirect needed');
          return null;
        },
        loading: () {
          debugPrint('⏳ [ROUTER] AppStartup loading...');
          // While loading, don't redirect (show current route or initial)
          return null;
        },
        error: (error, stackTrace) {
          debugPrint('❌ [ROUTER] AppStartup error: $error');
          // On error, treat as unauthenticated and go to landing
          final isGoingToProtected =
              state.matchedLocation == Routes.home ||
              state.matchedLocation == Routes.authorized;
          if (isGoingToProtected) {
            debugPrint(
              '🚫 [ROUTER] Error state + protected route -> Redirecting to /landing',
            );
            return Routes.landing;
          }
          return null;
        },
      );
    },
    routes: [
      GoRoute(
        path: Routes.landing,
        builder: (context, state) {
          return LandingScreen();
        },
      ),
      GoRoute(
        path: Routes.login,
        builder: (context, state) {
          return LoginScreen();
        },
      ),
      GoRoute(
        path: Routes.register,
        builder: (context, state) {
          return RegisterScreen();
        },
      ),
      GoRoute(
        path: Routes.home,
        builder: (context, state) {
          return HomeScreen();
        },
      ),
      GoRoute(
        path: Routes.authorized,
        builder: (context, state) {
          return AuthorizedScreen();
        },
      ),
    ],
  );
});
