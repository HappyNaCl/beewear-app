import 'package:beewear_app/domain/models/product.dart';
import 'package:beewear_app/ui/core/themes/colors.dart';
import 'package:beewear_app/ui/core/ui/product/product_card.dart';
import 'package:beewear_app/ui/core/ui/category_header.dart';
import 'package:beewear_app/ui/core/layout/main_layout.dart';
import 'package:beewear_app/ui/category/view_model/category_products_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CategoryPage extends ConsumerStatefulWidget {
  final String category;

  const CategoryPage({super.key, required this.category});

  @override
  ConsumerState<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends ConsumerState<CategoryPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Load more when user is 200px from the bottom
      ref
          .read(categoryProductsNotifierProvider(widget.category).notifier)
          .loadMoreProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(
      categoryProductsNotifierProvider(widget.category),
    );

    return MainLayout(
      currentIndex: 1, // Set to Search tab since this is a browsing page
      child: Column(
        children: [
          CategoryHeader(category: widget.category),
          Expanded(child: _buildProductsGrid()),
        ],
      ),
    );
  }

  Widget _buildProductsGrid() {
    final productsState = ref.watch(
      categoryProductsNotifierProvider(widget.category),
    );

    if (productsState.products.isEmpty && productsState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (productsState.products.isEmpty && productsState.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: AppColors.grey3, size: 48),
            const SizedBox(height: 16),
            Text(
              'Failed to load products',
              style: TextStyle(color: AppColors.grey3),
            ),
            const SizedBox(height: 8),
            Text(
              productsState.error!,
              style: TextStyle(color: AppColors.grey3, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (productsState.products.isEmpty) {
      return Center(
        child: Text(
          'No products found',
          style: TextStyle(color: AppColors.grey3, fontSize: 16),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          const double crossAxisSpacing = 12.0;
          final availableWidth = constraints.maxWidth;
          final tileWidth = (availableWidth - crossAxisSpacing) / 2;

          // ProductCard layout: AspectRatio(1) image + 88px info + 16px padding (8+8)
          const double infoAreaInnerHeight = 88.0;
          const double infoAreaVerticalPadding = 16.0;
          final tileHeight =
              tileWidth + infoAreaInnerHeight + infoAreaVerticalPadding;
          final childAspectRatio = tileWidth / tileHeight;

          return Column(
            children: [
              Expanded(
                child: GridView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(top: 16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: crossAxisSpacing,
                    mainAxisSpacing: 12,
                    childAspectRatio: childAspectRatio,
                  ),
                  itemCount: productsState.products.length,
                  itemBuilder: (context, index) {
                    final Product product = productsState.products[index];
                    return GestureDetector(
                      onTap: () {
                         context.pushNamed(
                           'product_detail',
                           extra: product,
                         );
                      },
                      child: ProductCard(product: product),
                    );
                  },
                ),
              ),
              if (productsState.isLoading && productsState.products.isNotEmpty)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
            ],
          );
        },
      ),
    );
  }
}
