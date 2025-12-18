import 'package:beewear_app/ui/core/layout/main_layout.dart';
import 'package:beewear_app/ui/core/ui/product/product_card.dart';
import 'package:beewear_app/ui/core/ui/search_bar.dart' as core_ui;
import 'package:beewear_app/ui/search/view_model/search_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SearchScreen extends ConsumerStatefulWidget {
  final String? initialQuery; 

  // We accept an optional initialQuery (passed from Router)
  const SearchScreen({super.key, this.initialQuery});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  
  @override
  void initState() {
    super.initState();
    // FIX 1: Auto-trigger search if a query was passed
    if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
      // Use Future.microtask to avoid "setState during build" errors
      Future.microtask(() {
        ref.read(searchViewModelProvider.notifier).search(widget.initialQuery!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7, 
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: state.results.length,
      itemBuilder: (context, index) {
        final product = state.results[index];
        
        // FIX 2: Wrap in GestureDetector so we can click results!
        return GestureDetector(
          onTap: () {
            context.pushNamed('product_detail', extra: product);
          },
          child: ProductCard(product: product),
        );
      },
    );
  }
}