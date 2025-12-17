import 'package:beewear_app/data/repositories/product/product_repository.dart';
import 'package:beewear_app/data/repositories/product/remote_product_repository.dart';
import 'package:beewear_app/domain/models/product.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchState {
  final List<Product> results;
  final bool isLoading;
  final String? error;

  const SearchState({
    this.results = const [],
    this.isLoading = false,
    this.error,
  });

  SearchState copyWith({
    List<Product>? results,
    bool? isLoading,
    String? error,
  }) {
    return SearchState(
      results: results ?? this.results,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class SearchViewModel extends StateNotifier<SearchState> {
  final ProductRepository _repository;

  SearchViewModel(this._repository) : super(const SearchState());

  Future<void> search(String query) async {
    if (query.isEmpty) return;

    state = state.copyWith(isLoading: true, error: null);
    
    try {
      debugPrint('🔍 [SEARCH] Searching for: $query');
      // Fetch page 0 for now
      final products = await _repository.searchProducts(query, 0);
      
      state = state.copyWith(
        isLoading: false,
        results: products,
      );
      debugPrint('[SEARCH] Found ${products.length} results');
    } catch (e) {
      debugPrint('[SEARCH] Error: $e');
      state = state.copyWith(
        isLoading: false,
        error: "Failed to search products",
      );
    }
  }

  void clearSearch() {
    state = const SearchState();
  }
}

final searchViewModelProvider = StateNotifierProvider<SearchViewModel, SearchState>((ref) {
  final repo = ref.watch(productRepositoryProvider);
  return SearchViewModel(repo);
});