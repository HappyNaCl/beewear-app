import 'package:beewear_app/data/repositories/product/product_repository.dart';
import 'package:beewear_app/data/repositories/product/remote_product_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductDetailState {
  final bool isLoading;
  final bool isSuccess;
  final String? error;
  final String? successMessage;

  ProductDetailState({
    this.isLoading = false, 
    this.isSuccess = false, 
    this.error,
    this.successMessage,
  });
}

class ProductDetailViewModel extends StateNotifier<ProductDetailState> {
  final ProductRepository _repo;

  ProductDetailViewModel(this._repo) : super(ProductDetailState());

  Future<void> addToCart(String productId) async {
    state = ProductDetailState(isLoading: true);
    try {
      final success = await _repo.addToCart(productId, 1);
      if (success) {
        state = ProductDetailState(isSuccess: true, successMessage: "Added to Cart");
      } else {
        state = ProductDetailState(error: "Failed to add to cart");
      }
    } catch (e) {
      state = ProductDetailState(error: e.toString());
    }
  }

  Future<void> deleteProduct(String productId) async {
    state = ProductDetailState(isLoading: true);
    try {
      final success = await _repo.deleteProduct(productId);
      if (success) {
        state = ProductDetailState(isSuccess: true, successMessage: "Product Deleted");
      } else {
        state = ProductDetailState(error: "Failed to delete product");
      }
    } catch (e) {
      state = ProductDetailState(error: e.toString());
    }
  }
}

final productDetailViewModelProvider =
    StateNotifierProvider.autoDispose<ProductDetailViewModel, ProductDetailState>((ref) {
  final repo = ref.watch(productRepositoryProvider);
  return ProductDetailViewModel(repo);
});