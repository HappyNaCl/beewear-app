import 'package:beewear_app/domain/models/product.dart';

class CartItem {
  final String id; 
  final Product product;
  final int quantity;

  CartItem({
    required this.id,
    required this.product,
    required this.quantity,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] ?? '',
      product: Product.fromJson(json['product']), 
      quantity: json['quantity'] ?? 1,
    );
  }
}