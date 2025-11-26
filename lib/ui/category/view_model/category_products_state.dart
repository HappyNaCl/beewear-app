import 'package:beewear_app/domain/models/product.dart';

class CategoryProductsState {
  final List<Product> products;
  final bool isLoading;
  final bool hasReachedEnd;
  final String? error;
  final int currentPage;

  const CategoryProductsState({
    this.products = const [],
    this.isLoading = false,
    this.hasReachedEnd = false,
    this.error,
    this.currentPage = 0,
  });

  CategoryProductsState copyWith({
    List<Product>? products,
    bool? isLoading,
    bool? hasReachedEnd,
    String? error,
    int? currentPage,
  }) {
    return CategoryProductsState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      error: error,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}
