import 'package:beewear_app/data/repositories/auth/remote_auth_repository.dart';
import 'package:beewear_app/data/source/local/token_storage.dart';
import 'package:beewear_app/data/source/remote/dto/request/refresh_request.dart';
import 'package:beewear_app/providers/user_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Represents the authentication state of the app
enum AuthState { loading, authenticated, unauthenticated }

/// Provider that handles app startup authentication check
final appStartupProvider = FutureProvider<AuthState>((ref) async {
  debugPrint('🚀 [APP_STARTUP] Starting authentication check...');

  final tokenStorage = ref.watch(tokenStorageProvider);
  final authRepository = ref.watch(authRepositoryProvider);
  final userNotifier = ref.read(currentUserProvider.notifier);

  try {
    // Check if access token exists in secure storage
    final accessToken = await tokenStorage.getAccessToken();
    debugPrint(
      '🔑 [APP_STARTUP] Access token exists: ${accessToken != null && accessToken.isNotEmpty}',
    );

    if (accessToken == null || accessToken.isEmpty) {
      debugPrint('❌ [APP_STARTUP] No access token found -> UNAUTHENTICATED');
      // No access token, user is not authenticated
      return AuthState.unauthenticated;
    }

    // Try to fetch user data with the existing access token
    try {
      debugPrint(
        '👤 [APP_STARTUP] Attempting to fetch user with /me endpoint...',
      );
      final user = await authRepository.getMe();
      debugPrint('✅ [APP_STARTUP] Successfully fetched user: ${user.email}');

      // Save user data to the global user provider
      userNotifier.setUser(user);
      debugPrint('✅ [APP_STARTUP] User data saved to provider');

      // User is authenticated
      debugPrint('✅ [APP_STARTUP] Final state: AUTHENTICATED');
      return AuthState.authenticated;
    } catch (e) {
      debugPrint('⚠️ [APP_STARTUP] /me failed: $e');
      debugPrint('🔄 [APP_STARTUP] Attempting to refresh token...');

      // If /me fails, try to refresh the token
      final refreshToken = await tokenStorage.getRefreshToken();
      debugPrint(
        '🔑 [APP_STARTUP] Refresh token exists: ${refreshToken != null && refreshToken.isNotEmpty}',
      );

      if (refreshToken == null || refreshToken.isEmpty) {
        debugPrint(
          '❌ [APP_STARTUP] No refresh token available -> Clearing storage',
        );
        // No refresh token available, clear everything
        await tokenStorage.clear();
        userNotifier.clearUser();
        debugPrint('❌ [APP_STARTUP] Final state: UNAUTHENTICATED');
        return AuthState.unauthenticated;
      }

      // Try to refresh the access token
      debugPrint('🔄 [APP_STARTUP] Calling /auth/refresh endpoint...');
      final request = RefreshRequest(refreshToken: refreshToken);
      final response = await authRepository.refresh(request);
      debugPrint('✅ [APP_STARTUP] Token refresh successful');

      // Save the new tokens
      await tokenStorage.saveTokens(
        response.accessToken,
        response.refreshToken,
      );
      debugPrint('✅ [APP_STARTUP] New tokens saved');

      // Fetch user data again with new token
      debugPrint('👤 [APP_STARTUP] Fetching user with new token...');
      final user = await authRepository.getMe();
      debugPrint('✅ [APP_STARTUP] Successfully fetched user: ${user.email}');

      // Save user data to the global user provider
      userNotifier.setUser(user);
      debugPrint('✅ [APP_STARTUP] User data saved to provider');

      // User is authenticated
      debugPrint('✅ [APP_STARTUP] Final state: AUTHENTICATED (after refresh)');
      return AuthState.authenticated;
    }
  } catch (e) {
    debugPrint('❌ [APP_STARTUP] Fatal error: $e');
    // If everything fails, clear tokens and mark as unauthenticated
    await tokenStorage.clear();
    userNotifier.clearUser();
    debugPrint('❌ [APP_STARTUP] Final state: UNAUTHENTICATED (after error)');
    return AuthState.unauthenticated;
  }
});
