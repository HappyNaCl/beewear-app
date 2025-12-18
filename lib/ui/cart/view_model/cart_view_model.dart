import 'package:beewear_app/data/repositories/product/product_repository.dart';
import 'package:beewear_app/data/repositories/product/remote_product_repository.dart';
import 'package:beewear_app/domain/models/cart_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartState {
  final List<CartItem> items;
  final bool isLoading;
  final String? error;

  CartState({
    this.items = const [],
    this.isLoading = false,
    this.error,
  });

  double get totalPrice => items.fold(
        0,
        (sum, item) => sum + (item.product.price * item.quantity),
      );
}

class CartViewModel extends StateNotifier<CartState> {
  final ProductRepository _repo;

  CartViewModel(this._repo) : super(CartState()) {
    loadCart();
  }

  Future<void> loadCart() async {
    state = CartState(isLoading: true);
    try {
      final items = await _repo.getCart();
      state = CartState(items: items, isLoading: false);
    } catch (e) {
      state = CartState(error: e.toString(), isLoading: false);
    }
  }

  Future<void> removeItem(String cartItemId) async {
    // Optimistic update: Remove from UI immediately
    final previousItems = state.items;
    state = CartState(
      items: state.items.where((i) => i.id != cartItemId).toList(),
      isLoading: false,
    );

    try {
      final success = await _repo.removeFromCart(cartItemId);
      if (!success) {
        // Revert if failed
        state = CartState(items: previousItems, error: "Failed to delete");
      }
    } catch (e) {
      state = CartState(items: previousItems, error: e.toString());
    }
  }
}

final cartViewModelProvider = StateNotifierProvider.autoDispose<CartViewModel, CartState>((ref) {
  final repo = ref.watch(productRepositoryProvider);
  return CartViewModel(repo);
});