import 'package:beewear_app/data/repositories/product/product_repository.dart';
import 'package:beewear_app/data/source/remote/api_service.dart';
import 'package:beewear_app/data/source/remote/dto/request/create_product_request.dart';
import 'package:beewear_app/domain/models/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RemoteProductRepository implements ProductRepository {
  final ApiService apiService;

  const RemoteProductRepository(this.apiService);

  @override
  Future<List<Product>> getRecentProducts({String? lastTimestamp}) async {
    final response = await apiService.getRecentProducts(
      lastTimestamp: lastTimestamp,
    );
    final data = response["data"] as List;
    return data.map((json) => Product.fromJson(json)).toList();
  }

  @override
  Future<List<Product>> getCategorizedProducts(
    String category,
    int page,
  ) async {
    final response = await apiService.getCategorizedProducts(category, page);
    final data = response["data"] as List;
    return data.map((json) => Product.fromJson(json)).toList();
  }

  @override
  Future<List<Product>> searchProducts(String query, int page) async {
    final response = await apiService.searchProducts(query, page);
    final data = response["data"] as List;
    return data.map((json) => Product.fromJson(json)).toList();
  }

  @override
  Future<bool> createProduct(CreateProductRequest req) async {
    final data = {
      "name": req.name,
      "description": req.description,
      "price": req.price,
      "gender": req.gender,
      "productCategory": req.category,
    };

    try {
      final res = await apiService.createProduct(data, req.images);
      return res != null;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Product?> getProductDetail(String id) async {
    try {
      final response = await apiService.getProductDetail(id);
      return Product.fromJson(response['data']);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> deleteProduct(String id) async {
    try {
      await apiService.deleteProduct(id);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> addToCart(String productId, int quantity) async {
    try {
      await apiService.addToCart({
        "productId": productId,
        "quantity": quantity
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return RemoteProductRepository(apiService);
});
