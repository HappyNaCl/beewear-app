import 'package:beewear_app/data/repositories/product/remote_product_repository.dart';
import 'package:beewear_app/domain/models/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recentProductsProvider = FutureProvider<List<Product>>((ref) async {
  final productRepository = ref.watch(productRepositoryProvider);
  return await productRepository.getRecentProducts();
});
