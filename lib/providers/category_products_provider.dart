import 'package:beewear_app/data/repositories/product/remote_product_repository.dart';
import 'package:beewear_app/domain/models/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoryProductsProvider = FutureProvider.family<List<Product>, String>((
  ref,
  category,
) async {
  final repo = ref.watch(productRepositoryProvider);
  final products = await repo.getCategorizedProducts(category, 0);
  return products;
});
