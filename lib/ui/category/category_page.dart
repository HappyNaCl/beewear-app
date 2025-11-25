import 'package:beewear_app/domain/models/product.dart';
import 'package:beewear_app/ui/core/themes/colors.dart';
import 'package:beewear_app/ui/core/ui/product/product_card.dart';
import 'package:beewear_app/ui/core/ui/category_header.dart';
import 'package:beewear_app/ui/core/layout/main_layout.dart';
import 'package:beewear_app/providers/category_products_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryPage extends ConsumerWidget {
  final String category;

  const CategoryPage({super.key, required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncProducts = ref.watch(categoryProductsProvider(category));

    return MainLayout(
      currentIndex: 1, // Set to Search tab since this is a browsing page
      child: Column(
        children: [
          CategoryHeader(category: category),
          Expanded(
            child: asyncProducts.when(
              data: (products) {
                if (products.isEmpty) {
                  return Center(
                    child: Text(
                      'No more products',
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
                          tileWidth +
                          infoAreaInnerHeight +
                          infoAreaVerticalPadding;
                      final childAspectRatio = tileWidth / tileHeight;

                      return GridView.builder(
                        padding: const EdgeInsets.only(top: 16),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: crossAxisSpacing,
                          mainAxisSpacing: 12,
                          childAspectRatio: childAspectRatio,
                        ),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final Product product = products[index];
                          return ProductCard(product: product);
                        },
                      );
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(
                child: Text(
                  'Failed to load products',
                  style: TextStyle(color: AppColors.grey3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
