import 'package:beewear_app/providers/app_startup_provider.dart';
import 'package:beewear_app/routing/routes.dart';
import 'package:beewear_app/ui/authorized/widgets/authorized_screen.dart';
import 'package:beewear_app/ui/landing/widgets/landing_screen.dart';
import 'package:beewear_app/ui/login/widgets/login_screen.dart';
import 'package:beewear_app/ui/register/widgets/register_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final appStartupState = ref.watch(appStartupProvider);

  return GoRouter(
    initialLocation: Routes.landing,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      // Check the auth state
      return appStartupState.when(
        data: (authState) {
          final isGoingToAuthorized =
              state.matchedLocation == Routes.authorized;
          final isAuthenticated = authState == AuthState.authenticated;

          // If user is authenticated and not going to authorized screen, redirect to authorized
          if (isAuthenticated && !isGoingToAuthorized) {
            return Routes.authorized;
          }

          // If user is not authenticated and trying to access authorized screen, redirect to landing
          if (!isAuthenticated && isGoingToAuthorized) {
            return Routes.landing;
          }

          // No redirect needed
          return null;
        },
        loading: () {
          // While loading, don't redirect (show current route or initial)
          return null;
        },
        error: (_, __) {
          // On error, treat as unauthenticated and go to landing
          final isGoingToAuthorized =
              state.matchedLocation == Routes.authorized;
          if (isGoingToAuthorized) {
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
        path: Routes.authorized,
        builder: (context, state) {
          return AuthorizedScreen();
        },
      ),
    ],
  );
});
