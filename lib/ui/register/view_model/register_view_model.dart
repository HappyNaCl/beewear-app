import 'package:beewear_app/data/repositories/auth/auth_repository.dart';
import 'package:beewear_app/data/repositories/auth/remote_auth_repository.dart';
import 'package:beewear_app/data/source/local/token_storage.dart';
import 'package:beewear_app/data/source/remote/dto/request/create_otp_request.dart';
import 'package:beewear_app/data/source/remote/dto/request/register_request.dart';
import 'package:beewear_app/data/source/remote/dto/response/auth_response.dart';
import 'package:beewear_app/domain/models/user.dart';
import 'package:beewear_app/providers/user_provider.dart';
import 'package:beewear_app/ui/register/view_model/register_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterViewModel extends StateNotifier<RegisterState> {
  final TokenStorage _tokenStorage;
  final AuthRepository _authRepository;
  final Ref _ref;

  RegisterViewModel(this._authRepository, this._tokenStorage, this._ref)
    : super(RegisterState());

  Future<bool> createOtp() async {
    if (state.email == null || state.email!.isEmpty) {
      state = state.copyWith(error: "Email is required");
      return false;
    }

    state = state.copyWith(isLoading: true, error: null);
    try {
      final data = CreateOtpRequest(email: state.email!);

      final success = await _authRepository.createOtp(data);
      state = state.copyWith(isLoading: false);
      return success;
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
      return false;
    }
  }

  Future<bool> register() async {
    if (state.username == null || state.username!.isEmpty) {
      state = state.copyWith(error: "Username is required");
      return false;
    }

    if (state.email == null || state.email!.isEmpty) {
      state = state.copyWith(error: "Email is required");
      return false;
    }

    if (state.password == null || state.password!.isEmpty) {
      state = state.copyWith(error: "Password is required");
      return false;
    }

    if (state.confirmPassword == null || state.confirmPassword!.isEmpty) {
      state = state.copyWith(error: "Confirm Password is required");
      return false;
    }

    if (state.password != state.confirmPassword) {
      state = state.copyWith(
        error: "Password and Confirm Password do not match",
      );
      return false;
    }

    if (state.gender == null || state.gender!.isEmpty) {
      state = state.copyWith(error: "Gender is required");
      return false;
    }

    state = state.copyWith(isLoading: true, error: null);
    try {
      final data = RegisterRequest(
        username: state.username!,
        email: state.email!,
        password: state.password!,
        confirmPassword: state.confirmPassword!,
        gender: state.gender!,
        otp: state.otp!,
      );

      AuthResponse res = await _authRepository.register(data);

      await _tokenStorage.saveTokens(res.accessToken, res.refreshToken);

      // Save user data to global provider
      final user = User(
        userId: res.userId,
        email: res.email,
        username: res.username,
        profilePicture: res.profilePicture,
      );
      _ref.read(currentUserProvider.notifier).setUser(user);

      state = state.copyWith(isLoading: false, isRegistered: true);

      return true;
    } on DioException catch (e) {
      String errorMessage = "Network error";
      if (e.response != null) {
        errorMessage = e.response?.data["error"] ?? "Server error";
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = "Connection timeout, server might not be running";
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = "Receive timeout";
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = "Cannot connect to server - check your env";
      }
      state = state.copyWith(error: errorMessage, isLoading: false);
      return false;
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
      return false;
    }
  }

  void setUsername(String? username) {
    state = state.copyWith(username: username);
  }

  void setEmail(String? email) {
    state = state.copyWith(email: email);
  }

  void setPassword(String? password) {
    state = state.copyWith(password: password);
  }

  void setConfirmPassword(String? confirmPassword) {
    state = state.copyWith(confirmPassword: confirmPassword);
  }

  void setGender(String? gender) {
    state = state.copyWith(gender: gender);
  }

  void setOtp(String? otp) {
    state = state.copyWith(otp: otp);
  }
}

final registerViewModelProvider =
    StateNotifierProvider<RegisterViewModel, RegisterState>((ref) {
      final authRepository = ref.watch(authRepositoryProvider);
      final tokenStorage = ref.watch(tokenStorageProvider);

      return RegisterViewModel(authRepository, tokenStorage, ref);
    });
