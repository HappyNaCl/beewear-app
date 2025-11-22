import 'package:beewear_app/data/repositories/product/product_repository.dart';
import 'package:beewear_app/data/repositories/product/remote_product_repository.dart';
import 'package:beewear_app/ui/home/view_model/products_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductsNotifier extends StateNotifier<ProductsState> {
  final ProductRepository _productRepository;

  ProductsNotifier(this._productRepository) : super(const ProductsState());

  Future<void> loadInitialProducts() async {
    debugPrint('📦 [PRODUCTS] Loading initial products...');
    state = state.copyWith(isLoading: true, error: null);

    try {
      final products = await _productRepository.getRecentProducts();
      debugPrint('📦 [PRODUCTS] Loaded ${products.length} products');

      final hasReachedEnd = products.length < 10;
      final lastTimestamp = products.isNotEmpty
          ? products.last.createdAt.toIso8601String()
          : null;

      debugPrint('📦 [PRODUCTS] Has reached end: $hasReachedEnd');
      debugPrint('📦 [PRODUCTS] Last timestamp: $lastTimestamp');

      state = state.copyWith(
        products: products,
        isLoading: false,
        hasReachedEnd: hasReachedEnd,
        lastTimestamp: lastTimestamp,
      );
    } catch (e) {
      debugPrint('❌ [PRODUCTS] Error loading products: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadMoreProducts() async {
    if (state.isLoading || state.hasReachedEnd) {
      debugPrint(
        '⏸️ [PRODUCTS] Skip loading more - isLoading: ${state.isLoading}, hasReachedEnd: ${state.hasReachedEnd}',
      );
      return;
    }

    debugPrint(
      '📦 [PRODUCTS] Loading more products with lastTimestamp: ${state.lastTimestamp}',
    );
    state = state.copyWith(isLoading: true, error: null);

    try {
      final newProducts = await _productRepository.getRecentProducts(
        lastTimestamp: state.lastTimestamp,
      );
      debugPrint('📦 [PRODUCTS] Loaded ${newProducts.length} more products');

      final hasReachedEnd = newProducts.length < 10;
      final lastTimestamp = newProducts.isNotEmpty
          ? newProducts.last.createdAt.toIso8601String()
          : state.lastTimestamp;

      debugPrint('📦 [PRODUCTS] Has reached end: $hasReachedEnd');
      debugPrint('📦 [PRODUCTS] New last timestamp: $lastTimestamp');

      state = state.copyWith(
        products: [...state.products, ...newProducts],
        isLoading: false,
        hasReachedEnd: hasReachedEnd,
        lastTimestamp: lastTimestamp,
      );
    } catch (e) {
      debugPrint('❌ [PRODUCTS] Error loading more products: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void refresh() {
    debugPrint('🔄 [PRODUCTS] Refreshing products...');
    state = const ProductsState();
    loadInitialProducts();
  }
}

final productsNotifierProvider =
    StateNotifierProvider<ProductsNotifier, ProductsState>((ref) {
      final productRepository = ref.watch(productRepositoryProvider);
      final notifier = ProductsNotifier(productRepository);
      notifier.loadInitialProducts();
      return notifier;
    });
