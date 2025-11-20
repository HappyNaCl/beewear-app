import 'package:beewear_app/data/source/remote/dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ApiService {
  final Dio dio;
  ApiService(this.dio);

  Future<dynamic> getRegion() async {
    final res = await dio.get("/region");
    return res.data;
  }

  Future<dynamic> refresh(Map<String, dynamic> data) async {
    final res = await dio.post("/auth/refresh", data: data);
    return res.data;
  }

  Future<dynamic> register(Map<String, dynamic> data) async {
    final res = await dio.post("/auth/register", data: data);
    return res.data;
  }

  Future<dynamic> createOtp(Map<String, dynamic> data) async {
    final res = await dio.post("/auth/otp/create", data: data);
    return res.statusCode == 201;
  }

  Future<dynamic> login(Map<String, dynamic> data) async {
    final res = await dio.post("/auth/login", data: data);
    return res.data;
  }
}

final apiServiceProvider = Provider<ApiService>((ref) {
  final dio = ref.watch(dioProvider);
  return ApiService(dio);
});
