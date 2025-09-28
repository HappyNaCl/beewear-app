import 'package:beewear_app/routing/routes.dart';
import 'package:beewear_app/ui/landing/widgets/landing_screen.dart';
import 'package:beewear_app/ui/login/widgets/login_screen.dart';
import 'package:beewear_app/ui/register/widgets/register_screen.dart';
import 'package:go_router/go_router.dart';

GoRouter router() => GoRouter(
  initialLocation: Routes.landing,
  debugLogDiagnostics: true,
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
      }
    )
  ]
);