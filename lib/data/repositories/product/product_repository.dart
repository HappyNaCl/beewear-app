import 'package:beewear_app/data/source/remote/dto/request/create_product_request.dart';
import 'package:beewear_app/domain/models/product.dart';
import 'package:beewear_app/domain/models/cart_item.dart';

abstract class ProductRepository {
  Future<List<Product>> getRecentProducts({String? lastTimestamp});
  Future<List<Product>> getCategorizedProducts(String category, int page);
  Future<List<Product>> searchProducts(String query, int page);
  Future<bool> createProduct(CreateProductRequest request);
  Future<Product?> getProductDetail(String id);
  Future<bool> deleteProduct(String id);
  Future<bool> addToCart(String productId, int quantity);
  Future<List<CartItem>> getCart();
  Future<bool> removeFromCart(String cartItemId);
}
