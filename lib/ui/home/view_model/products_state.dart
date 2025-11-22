import 'package:beewear_app/domain/models/product.dart';

class ProductsState {
  final List<Product> products;
  final bool isLoading;
  final bool hasReachedEnd;
  final String? error;
  final String? lastTimestamp;

  const ProductsState({
    this.products = const [],
    this.isLoading = false,
    this.hasReachedEnd = false,
    this.error,
    this.lastTimestamp,
  });

  ProductsState copyWith({
    List<Product>? products,
    bool? isLoading,
    bool? hasReachedEnd,
    String? error,
    String? lastTimestamp,
  }) {
    return ProductsState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      error: error,
      lastTimestamp: lastTimestamp ?? this.lastTimestamp,
    );
  }
}
