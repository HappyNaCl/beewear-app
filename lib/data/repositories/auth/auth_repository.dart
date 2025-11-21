import 'package:beewear_app/data/source/remote/dto/request/create_otp_request.dart';
import 'package:beewear_app/data/source/remote/dto/request/login_request.dart';
import 'package:beewear_app/data/source/remote/dto/request/refresh_request.dart';
import 'package:beewear_app/data/source/remote/dto/request/register_request.dart';
import 'package:beewear_app/data/source/remote/dto/response/auth_response.dart';
import 'package:beewear_app/data/source/remote/dto/response/refresh_response.dart';
import 'package:beewear_app/domain/models/user.dart';

abstract class AuthRepository {
  Future<AuthResponse> login(LoginRequest request);
  Future<AuthResponse> register(RegisterRequest data);
  Future<bool> createOtp(CreateOtpRequest req);
  Future<RefreshResponse> refresh(RefreshRequest request);
  Future<User> getMe();
}
