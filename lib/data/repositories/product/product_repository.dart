import 'package:beewear_app/domain/models/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getRecentProducts();
}
