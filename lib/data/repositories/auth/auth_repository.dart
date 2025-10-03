import 'package:beewear_app/data/source/remote/dto/request/create_otp_request.dart';
import 'package:beewear_app/data/source/remote/dto/request/login_request.dart';
import 'package:beewear_app/data/source/remote/dto/request/register_request.dart';
import 'package:beewear_app/data/source/remote/dto/response/auth_response.dart';

abstract class AuthRepository {
  Future<AuthResponse> login(LoginRequest request);
  Future<AuthResponse> register(RegisterRequest data);
  Future<bool> createOtp(CreateOtpRequest req);
}