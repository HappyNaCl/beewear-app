import 'package:beewear_app/data/source/remote/dto/request/create_product_request.dart';
import 'package:beewear_app/domain/models/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getRecentProducts({String? lastTimestamp});
  Future<List<Product>> getCategorizedProducts(String category, int page);
  Future<List<Product>> searchProducts(String query, int page);
  Future<bool> createProduct(CreateProductRequest request);
}
