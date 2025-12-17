import 'package:beewear_app/ui/core/layout/main_layout.dart';
import 'package:beewear_app/ui/core/ui/product/product_card.dart';
import 'package:beewear_app/ui/core/ui/search_bar.dart' as core_ui;
import 'package:beewear_app/ui/search/view_model/search_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(searchViewModelProvider);
    final viewModel = ref.read(searchViewModelProvider.notifier);

    return MainLayout(
      currentIndex: 1,
      child: SafeArea(
        child: Column(
          children: [
            core_ui.SearchBar(
              hintText: "Search products...",
              onSubmitted: (query) {
                viewModel.search(query);
              },
            ),
            Expanded(
              child: _buildBody(searchState),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(SearchState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(child: Text(state.error!));
    }

    if (state.results.isEmpty) {
      return const Center(
        child: Text("Search for clothes, shoes, and more!"),
      );
    }

    // Reuse your Grid logic from other screens
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7, // Adjust based on your ProductCard aspect ratio
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: state.results.length,
      itemBuilder: (context, index) {
        return ProductCard(product: state.results[index]);
      },
    );
  }
}