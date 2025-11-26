import 'package:beewear_app/data/repositories/product/product_repository.dart';
import 'package:beewear_app/data/repositories/product/remote_product_repository.dart';
import 'package:beewear_app/ui/category/view_model/category_products_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryProductsNotifier extends StateNotifier<CategoryProductsState> {
  final ProductRepository _productRepository;
  final String category;

  CategoryProductsNotifier(this._productRepository, this.category)
    : super(const CategoryProductsState());

  Future<void> loadInitialProducts() async {
    debugPrint(
      '📦 [CATEGORY_PRODUCTS] Loading initial products for $category...',
    );
    state = state.copyWith(isLoading: true, error: null);

    try {
      final products = await _productRepository.getCategorizedProducts(
        category,
        0,
      );
      debugPrint('📦 [CATEGORY_PRODUCTS] Loaded ${products.length} products');

      final hasReachedEnd = products.length < 10;

      debugPrint('📦 [CATEGORY_PRODUCTS] Has reached end: $hasReachedEnd');
      debugPrint('📦 [CATEGORY_PRODUCTS] Current page: 0');

      state = state.copyWith(
        products: products,
        isLoading: false,
        hasReachedEnd: hasReachedEnd,
        currentPage: 0,
      );
    } catch (e) {
      debugPrint('❌ [CATEGORY_PRODUCTS] Error loading products: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadMoreProducts() async {
    if (state.isLoading || state.hasReachedEnd) {
      debugPrint(
        '⏸️ [CATEGORY_PRODUCTS] Skip loading more - isLoading: ${state.isLoading}, hasReachedEnd: ${state.hasReachedEnd}',
      );
      return;
    }

    final nextPage = state.currentPage + 1;
    debugPrint(
      '📦 [CATEGORY_PRODUCTS] Loading more products for $category, page: $nextPage',
    );
    state = state.copyWith(isLoading: true, error: null);

    try {
      final newProducts = await _productRepository.getCategorizedProducts(
        category,
        nextPage,
      );
      debugPrint(
        '📦 [CATEGORY_PRODUCTS] Loaded ${newProducts.length} more products',
      );

      final hasReachedEnd = newProducts.length < 10;

      debugPrint('📦 [CATEGORY_PRODUCTS] Has reached end: $hasReachedEnd');
      debugPrint('📦 [CATEGORY_PRODUCTS] Current page: $nextPage');

      state = state.copyWith(
        products: [...state.products, ...newProducts],
        isLoading: false,
        hasReachedEnd: hasReachedEnd,
        currentPage: nextPage,
      );
    } catch (e) {
      debugPrint('❌ [CATEGORY_PRODUCTS] Error loading more products: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void refresh() {
    debugPrint('🔄 [CATEGORY_PRODUCTS] Refreshing products for $category...');
    state = const CategoryProductsState();
    loadInitialProducts();
  }
}

final categoryProductsNotifierProvider =
    StateNotifierProvider.family<
      CategoryProductsNotifier,
      CategoryProductsState,
      String
    >((ref, category) {
      final productRepository = ref.watch(productRepositoryProvider);
      final notifier = CategoryProductsNotifier(productRepository, category);
      notifier.loadInitialProducts();
      return notifier;
    });
