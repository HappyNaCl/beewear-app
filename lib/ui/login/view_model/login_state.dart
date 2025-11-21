class LoginState {
  final bool isLoading;
  final String? error;
  final bool isLoggedIn;
  final String? email;
  final String? password;

  const LoginState({
    this.isLoading = false,
    this.error,
    this.isLoggedIn = false,
    this.email,
    this.password,
  });

  LoginState copyWith({
    bool? isLoading,
    String? error,
    bool? isLoggedIn,
    String? email,
    String? password,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}
