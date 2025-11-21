class MeResponse {
  final String userId;
  final String email;
  final String username;
  final String? profilePicture;

  MeResponse({
    required this.userId,
    required this.email,
    required this.username,
    this.profilePicture,
  });

  factory MeResponse.fromJson(Map<String, dynamic> json) {
    return MeResponse(
      userId: json['userId'],
      email: json['email'],
      username: json['username'],
      profilePicture: json['profilePicture'],
    );
  }
}
