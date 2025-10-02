class CreateOtpRequest {
  final String email;

  CreateOtpRequest({
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}