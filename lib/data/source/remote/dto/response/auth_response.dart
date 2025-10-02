class AuthResponse {
  final String userId;
  final String email;
  final String username;
  final String? profilePicture;
  final String refreshToken;
  final String accessToken;

  AuthResponse({
    required this.userId,
    required this.email,
    required this.username,
    this.profilePicture,
    required this.refreshToken,
    required this.accessToken,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      userId: json['userId'],
      email: json['email'],
      username: json['username'],
      profilePicture: json['profilePicture'],
      refreshToken: json['refreshToken'],
      accessToken: json['accessToken'],
    );
  }
}