import 'package:beewear_app/data/repositories/auth/auth_repository.dart';
import 'package:beewear_app/data/repositories/auth/remote_auth_repository.dart';
import 'package:beewear_app/data/repositories/region/region_repository.dart';
import 'package:beewear_app/data/repositories/region/remote_region_repository.dart';
import 'package:beewear_app/data/source/local/token_storage.dart';
import 'package:beewear_app/data/source/remote/dto/request/create_otp_request.dart';
import 'package:beewear_app/data/source/remote/dto/request/register_request.dart';
import 'package:beewear_app/data/source/remote/dto/response/auth_response.dart';
import 'package:beewear_app/domain/models/region.dart';
import 'package:beewear_app/ui/register/view_model/register_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterViewModel extends StateNotifier<RegisterState> {

  final TokenStorage _tokenStorage;
  final RegionRepository _regionRepository;
  final AuthRepository _authRepository;

  RegisterViewModel(this._regionRepository, this._authRepository, this._tokenStorage) : super(RegisterState());

  Future<void> loadRegions() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final regions = await _regionRepository.fetchRegions();
      state = state.copyWith(regions: regions, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<bool> createOtp() async {
    if(state.email == null || state.email!.isEmpty) {
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
    if(state.username == null || state.username!.isEmpty) {
      state = state.copyWith(error: "Username is required");
      return false;
    }
    if(state.email == null || state.email!.isEmpty) {
      state = state.copyWith(error: "Email is required");
      return false;
    }
    if(state.password == null || state.password!.isEmpty) {
      state = state.copyWith(error: "Password is required");
      return false;
    }
    if(state.confirmPassword == null || state.confirmPassword!.isEmpty) {
      state = state.copyWith(error: "Confirm Password is required");
      return false;
    }
    if(state.password != state.confirmPassword) {
      state = state.copyWith(error: "Password and Confirm Password do not match");
      return false;
    }
    if(state.selectedRegion == null) {
      state = state.copyWith(error: "Region is required");
      return false;
    }

    state = state.copyWith(isLoading: true, error: null);
    try {
      final data = RegisterRequest(
        username: state.username!,
        email: state.email!,
        password: state.password!,
        confirmPassword: state.confirmPassword!,
        otp: state.otp!,
        regionId: state.selectedRegion!.id,
      );

      AuthResponse res = await _authRepository.register(data);

      await _tokenStorage.saveTokens(res.accessToken, res.refreshToken);

      state = state.copyWith(isLoading: false);

      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
      return false;
    }
  }

  void selectRegion(Region? region) {
    state = state.copyWith(selectedRegion: region);
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

  void setOtp(String? otp) {
    state = state.copyWith(otp: otp);
  }
}

final registerViewModelProvider = StateNotifierProvider<RegisterViewModel, RegisterState>((ref) {
  final regionRepository = ref.watch(regionRepositoryProvider);
  final authRepository = ref.watch(authRepositoryProvider);
  final tokenStorage = ref.watch(tokenStorageProvider);

  return RegisterViewModel(regionRepository, authRepository, tokenStorage);
});