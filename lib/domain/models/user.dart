class User {
  final String userId;
  final String email;
  final String username;
  final String? profilePicture;

  const User({
    required this.userId,
    required this.email,
    required this.username,
    this.profilePicture,
  });

  factory User.fromAuthResponse(Map<String, dynamic> data) {
    return User(
      userId: data['userId'],
      email: data['email'],
      username: data['username'],
      profilePicture: data['profilePicture'],
    );
  }

  factory User.fromMeResponse(Map<String, dynamic> json) {
    return User(
      userId: json['id'],
      email: json['email'],
      username: json['username'],
      profilePicture: json['profilePicture'],
    );
  }

  User copyWith({
    String? userId,
    String? email,
    String? username,
    String? profilePicture,
  }) {
    return User(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      username: username ?? this.username,
      profilePicture: profilePicture ?? this.profilePicture,
    );
  }
}
