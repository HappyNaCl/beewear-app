import 'package:beewear_app/data/repositories/product/product_repository.dart';
import 'package:beewear_app/data/source/remote/api_service.dart';
import 'package:beewear_app/domain/models/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RemoteProductRepository implements ProductRepository {
  final ApiService apiService;

  const RemoteProductRepository(this.apiService);

  @override
  Future<List<Product>> getRecentProducts() async {
    final response = await apiService.getRecentProducts();
    final data = response["data"] as List;
    return data.map((json) => Product.fromJson(json)).toList();
  }
}

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return RemoteProductRepository(apiService);
});
