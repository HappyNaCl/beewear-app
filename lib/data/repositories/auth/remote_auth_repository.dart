import 'package:beewear_app/data/repositories/auth/auth_repository.dart';
import 'package:beewear_app/data/source/remote/api_service.dart';
import 'package:beewear_app/data/source/remote/dto/request/create_otp_request.dart';
import 'package:beewear_app/data/source/remote/dto/request/login_request.dart';
import 'package:beewear_app/data/source/remote/dto/request/register_request.dart';
import 'package:beewear_app/data/source/remote/dto/response/auth_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RemoteAuthRepository implements AuthRepository {
  final ApiService apiService;

  const RemoteAuthRepository(this.apiService);

  @override
  Future<bool> createOtp(CreateOtpRequest req) async {
    return await apiService.createOtp(req.toJson());
  }

  @override
  Future<AuthResponse> login(LoginRequest request) async {
    final response = await apiService.login(request.toJson());
    final data = response["data"];
    final authResponse = AuthResponse.fromJson(data);
    return authResponse;
  }

  @override
  Future<AuthResponse> register(RegisterRequest req) async {
    final response = await apiService.register(req.toJson());
    final data = response["data"];
    final authResponse = AuthResponse.fromJson(data);
    return authResponse;
  }

  @override
  Future<String> verifyOtp(Map<String, dynamic> data) {
    // TODO: implement verifyOtp
    throw UnimplementedError();
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return RemoteAuthRepository(apiService);
});
