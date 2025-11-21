import 'package:beewear_app/data/repositories/auth/auth_repository.dart';
import 'package:beewear_app/data/repositories/auth/remote_auth_repository.dart';
import 'package:beewear_app/data/source/local/token_storage.dart';
import 'package:beewear_app/data/source/remote/dto/request/login_request.dart';
import 'package:beewear_app/data/source/remote/dto/response/auth_response.dart';
import 'package:beewear_app/domain/models/user.dart';
import 'package:beewear_app/providers/user_provider.dart';
import 'package:beewear_app/ui/login/view_model/login_state.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

class LoginViewModel extends StateNotifier<LoginState> {
  final AuthRepository _authRepository;
  final TokenStorage _tokenStorage;
  final Ref _ref;

  LoginViewModel(this._authRepository, this._tokenStorage, this._ref)
    : super(const LoginState());

  void setEmail(String? email) {
    state = state.copyWith(email: email);
  }

  void setPassword(String? password) {
    state = state.copyWith(password: password);
  }

  Future<bool> login() async {
    if (state.email == null || state.email!.isEmpty) {
      state = state.copyWith(error: "Email is required");
      return false;
    }
    if (state.password == null || state.password!.isEmpty) {
      state = state.copyWith(error: "Password is required");
      return false;
    }
    state = state.copyWith(isLoading: true, error: null);

    try {
      final loginRequest = LoginRequest(
        email: state.email!,
        password: state.password!,
      );

      AuthResponse response = await _authRepository.login(loginRequest);
      await _tokenStorage.saveTokens(
        response.accessToken,
        response.refreshToken,
      );

      // Save user data to global provider
      final user = User(
        userId: response.userId,
        email: response.email,
        username: response.username,
        profilePicture: response.profilePicture,
      );
      _ref.read(currentUserProvider.notifier).setUser(user);

      state = state.copyWith(isLoading: false, isLoggedIn: true);
      return true;
    } on DioException catch (e) {
      String errorMessage = "Network error occured";
      if (e.response != null) {
        final errorData = e.response?.data;
        if (errorData is Map<String, dynamic> && errorData["error"] != null) {
          errorMessage = errorData["error"];
        } else {
          errorMessage = "Server error";
        }
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = "Connection timeout";
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = "Receive timeout";
      }
      state = state.copyWith(error: errorMessage, isLoading: false);
      return false;
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
      return false;
    }
  }
}

final loginViewModelProvider =
    StateNotifierProvider<LoginViewModel, LoginState>((ref) {
      final authRepository = ref.watch(authRepositoryProvider);
      final tokenStorage = ref.watch(tokenStorageProvider);
      return LoginViewModel(authRepository, tokenStorage, ref);
    });
