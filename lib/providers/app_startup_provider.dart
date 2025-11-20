import 'package:beewear_app/data/repositories/auth/remote_auth_repository.dart';
import 'package:beewear_app/data/source/local/token_storage.dart';
import 'package:beewear_app/data/source/remote/dto/request/refresh_request.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Represents the authentication state of the app
enum AuthState { loading, authenticated, unauthenticated }

/// Provider that handles app startup authentication check
final appStartupProvider = FutureProvider<AuthState>((ref) async {
  final tokenStorage = ref.watch(tokenStorageProvider);
  final authRepository = ref.watch(authRepositoryProvider);

  try {
    // Check if refresh token exists in secure storage
    final refreshToken = await tokenStorage.getRefreshToken();

    if (refreshToken == null || refreshToken.isEmpty) {
      // No refresh token, user is not authenticated
      return AuthState.unauthenticated;
    }

    // Try to refresh the access token
    final request = RefreshRequest(refreshToken: refreshToken);
    final response = await authRepository.refresh(request);

    // Save the new tokens
    await tokenStorage.saveTokens(response.accessToken, response.refreshToken);

    // User is authenticated
    return AuthState.authenticated;
  } catch (e) {
    // If refresh fails, clear tokens and mark as unauthenticated
    await tokenStorage.clear();
    return AuthState.unauthenticated;
  }
});
