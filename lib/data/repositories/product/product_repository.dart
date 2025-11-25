import 'package:beewear_app/domain/models/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getRecentProducts({String? lastTimestamp});
  Future<List<Product>> getCategorizedProducts(String category, int page);
}
