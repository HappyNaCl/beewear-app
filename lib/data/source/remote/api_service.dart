import 'package:beewear_app/data/source/remote/dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ApiService {
  final Dio dio;
  ApiService(this.dio);

  Future<dynamic> getProfile() async {
    final res = await dio.get("/user/profile");
    return res.data;
  }

  Future<dynamic> getRegion() async {
    final res = await dio.get("/region");
    return res.data;
  }
}

final apiServiceProvider = Provider<ApiService>((ref) {
  final dio = ref.watch(dioProvider);
  return ApiService(dio);
});

