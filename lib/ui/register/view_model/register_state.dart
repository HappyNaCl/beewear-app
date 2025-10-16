import 'package:beewear_app/domain/models/region.dart';

class RegisterState {
  final List<Region> regions;
  final bool isLoading;
  final String? error;

  final Region? selectedRegion;
  final String? username;
  final String? email;
  final String? password;
  final String? confirmPassword;
  final String? gender;
  final String? otp;

  const RegisterState({
    this.regions = const [],
    this.selectedRegion,
    this.isLoading = false,
    this.error,
    this.username,
    this.email,
    this.password,
    this.confirmPassword,
    this.gender,
    this.otp,
  });

  RegisterState copyWith({
    List<Region>? regions,
    Region? selectedRegion,
    bool? isLoading,
    String? error,
    String? username,
    String? email,
    String? password,
    String? confirmPassword,
    String? gender,
    String? otp,
  }) {
    return RegisterState(
      regions: regions ?? this.regions,
      selectedRegion: selectedRegion ?? this.selectedRegion,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      gender: gender ?? this.gender,
      otp: otp ?? this.otp
    );
  }
}
