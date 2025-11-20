class RefreshResponse {
  final String accessToken;
  final String refreshToken;

  RefreshResponse({required this.accessToken, required this.refreshToken});

  factory RefreshResponse.fromJson(Map<String, dynamic> json) {
    return RefreshResponse(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }
}
