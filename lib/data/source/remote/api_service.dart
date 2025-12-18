import 'dart:io';

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

  Future<dynamic> getMe() async {
    final res = await dio.get("/me");
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

  Future<dynamic> getRecentProducts({String? lastTimestamp}) async {
    final res = await dio.get(
      "/product/recent",
      queryParameters: lastTimestamp != null
          ? {"lastTimestamp": lastTimestamp}
          : null,
    );
    return res.data;
  }

  Future<dynamic> getCategorizedProducts(String category, int page) async {
    final res = await dio.get(
      "/product/search",
      queryParameters: {
        "category": category,
        "page": page,
        "size": 10,
        "sort": "createdAt",
      },
    );
    return res.data;
  }

  Future<dynamic> searchProducts(String query, int page) async {
    final res = await dio.get(
      "/product/search",
      queryParameters: {
        "query": query, 
        "page": page,
        "size": 10,
        "sort": "createdAt",
      },
    );
    return res.data;
  }

  Future<dynamic> createProduct(
    Map<String, dynamic> data,
    List<File> images,
  ) async {
    final formData = FormData.fromMap(data);

    for (var file in images) {
      String fileName = file.path.split('/').last;
      formData.files.add(MapEntry(
        "images",
        await MultipartFile.fromFile(file.path, filename: fileName),
      ));
    }

    final res = await dio.post(
      "/product", 
      data: formData,
    );
    return res.data;
  }

  Future<dynamic> getProductDetail(String id) async {
    final res = await dio.get("/product/$id");
    return res.data;
  }

  Future<dynamic> deleteProduct(String id) async {
    await dio.delete("/product/$id");
    return true; 
  }

  Future<dynamic> addToCart(Map<String, dynamic> data) async {
    final res = await dio.post("/cart", data: data);
    return res.data;
  }

  Future<dynamic> getCart() async {
    final res = await dio.get("/cart");
    return res.data;
  }

  Future<dynamic> removeFromCart(String cartItemId) async {
    final res = await dio.delete("/cart/$cartItemId");
    return res.data;
  }

  Future<dynamic> getMyStats() async {
    final res = await dio.get("/product/me/stats");
    return res.data;
  }

  Future<dynamic> getMyProducts() async {
    final res = await dio.get("/product/me");
    return res.data;
  }
}

final apiServiceProvider = Provider<ApiService>((ref) {
  final dio = ref.watch(dioProvider);
  return ApiService(dio);
});
