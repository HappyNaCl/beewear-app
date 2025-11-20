class RegisterState {
  final bool isLoading;
  final String? error;
  final bool isRegistered;

  final String? username;
  final String? email;
  final String? password;
  final String? confirmPassword;
  final String? gender;
  final String? otp;

  const RegisterState({
    this.isLoading = false,
    this.error,
    this.isRegistered = false,
    this.username,
    this.email,
    this.password,
    this.confirmPassword,
    this.gender,
    this.otp,
  });

  RegisterState copyWith({
    bool? isLoading,
    String? error,
    bool? isRegistered,
    String? username,
    String? email,
    String? password,
    String? confirmPassword,
    String? gender,
    String? otp,
  }) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isRegistered: isRegistered ?? this.isRegistered,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      gender: gender ?? this.gender,
      otp: otp ?? this.otp,
    );
  }
}
