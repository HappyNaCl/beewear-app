import 'package:beewear_app/domain/models/product.dart';
import 'package:beewear_app/providers/app_startup_provider.dart';
import 'package:beewear_app/routing/routes.dart';
import 'package:beewear_app/ui/authorized/widgets/authorized_screen.dart';
import 'package:beewear_app/ui/home/widgets/home_screen.dart';
import 'package:beewear_app/ui/landing/widgets/landing_screen.dart';
import 'package:beewear_app/ui/login/widgets/login_screen.dart';
import 'package:beewear_app/ui/product_detail/widgets/product_detail_screen.dart';
import 'package:beewear_app/ui/register/widgets/register_screen.dart';
import 'package:beewear_app/ui/search/widgets/search_screen.dart';
import 'package:beewear_app/ui/cart/widgets/cart_screen.dart';
import 'package:beewear_app/ui/add_product/widgets/add_product_screen.dart';
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
          // final isGoingToProfile = state.matchedLocation == Routes.profile;
          final isGoingToAddProduct =
              state.matchedLocation == Routes.addProduct;
          final isGoingToCart = state.matchedLocation == Routes.cart;
          final isGoingToProductDetail = state.matchedLocation == Routes.productDetail;

          final isGoingToProtectedRoute =
              isGoingToHome || isGoingToAddProduct || isGoingToCart || isGoingToProductDetail;

          final isPublicRoute =
              state.matchedLocation == Routes.landing ||
              state.matchedLocation == Routes.login ||
              state.matchedLocation == Routes.register;

          final isAuthenticated = authState == AuthState.authenticated;

          debugPrint('🔄 [ROUTER] isAuthenticated: $isAuthenticated');
          debugPrint('🔄 [ROUTER] isGoingToHome: $isGoingToHome');
          debugPrint('🔄 [ROUTER] isPublicRoute: $isPublicRoute');

          if (isAuthenticated && isPublicRoute) {
            debugPrint(
              '🏠 [ROUTER] Authenticated user on public route -> Redirecting to /home',
            );
            return Routes.home;
          }

          if (isAuthenticated && isPublicRoute) {
            return Routes.home;
          }

          // 2. If logged in and trying to go somewhere valid, let them pass
          if (isAuthenticated && isGoingToProtectedRoute) {
            return null; // Allow navigation
          }

          // 3. If logged in but route is unknown (e.g. 404), go to Home
          if (isAuthenticated && !isGoingToProtectedRoute) {
            debugPrint(
              '🏠 [ROUTER] Authenticated but unknown route -> Redirecting to /home',
            );
            return Routes.home;
          }

          // 4. If NOT logged in and trying to access private pages, kick to Landing
          if (!isAuthenticated && isGoingToProtectedRoute) {
            return Routes.landing;
          }

          return null;
        },
        loading: () => null,
        error: (_, __) => Routes.landing,
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
        path: Routes.addProduct,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: AddProductScreen()),
      ),
      GoRoute(
        path: Routes.cart,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: CartScreen()),
      ),
      GoRoute(
        path: Routes.authorized,
        builder: (context, state) {
          return AuthorizedScreen();
        },
      ),
      GoRoute(
        path: '/product', 
        name: 'product_detail',
        pageBuilder: (context, state) {
          final product = state.extra as Product;
          return NoTransitionPage(child: ProductDetailScreen(product: product));
        },
      ),
    ],
  );
});
