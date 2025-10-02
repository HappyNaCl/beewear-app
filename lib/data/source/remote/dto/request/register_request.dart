class RegisterRequest {
  final String email;
  final String username;
  final String password;
  final String confirmPassword;
  final String otp;
  final String regionId;

  RegisterRequest({
    required this.email,
    required this.username,
    required this.password,
    required this.confirmPassword,
    required this.otp,
    required this.regionId,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'username': username,
      'password': password,
      'confirmPassword': confirmPassword,
      'otpSessionId': otp,
      'regionId': regionId,
    };
  }
}