import 'package:beewear_app/domain/models/product.dart';
import 'package:beewear_app/ui/core/themes/colors.dart';
import 'package:beewear_app/ui/home/view_model/products_notifier.dart';
import 'package:beewear_app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beewear_app/ui/core/ui/search_bar.dart' as core_ui;
import 'package:beewear_app/ui/core/ui/product/product_card.dart';
import 'package:beewear_app/ui/core/layout/main_layout.dart';
import 'package:beewear_app/ui/category/category_page.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
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
      ref.read(productsNotifierProvider.notifier).loadMoreProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);

    if (currentUser == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return MainLayout(
      currentIndex: 0,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.secondary],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                // Top bar with search
                core_ui.SearchBar(
                  hintText: 'Search...',
                  onSubmitted: (q) {
                    // TODO: Navigate to search or trigger search
                  },
                ),

                // Profile Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.blackTransparent,
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        children: [
                          // Profile Picture
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.primary,
                                width: 3,
                              ),
                            ),
                            child: currentUser.profilePicture != null
                                ? CircleAvatar(
                                    radius: 35,
                                    backgroundImage: NetworkImage(
                                      currentUser.profilePicture!,
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: 35,
                                    backgroundColor: AppColors.grey1,
                                    child: Icon(
                                      Icons.person,
                                      size: 40,
                                      color: AppColors.primary,
                                    ),
                                  ),
                          ),
                          const SizedBox(width: 16),
                          // User Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome back,',
                                  style: TextStyle(
                                    color: AppColors.grey3,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  currentUser.username,
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  currentUser.email,
                                  style: TextStyle(
                                    color: AppColors.grey3,
                                    fontSize: 13,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Categories section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.blackTransparent,
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Categories',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildCategoryButton(
                              icon: Icons.checkroom,
                              title: 'TOP',
                              color: AppColors.primary,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const CategoryPage(category: 'TOP'),
                                  ),
                                );
                              },
                            ),
                            _buildCategoryButton(
                              icon: Icons.person,
                              title: 'BOTTOM',
                              color: AppColors.secondary,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const CategoryPage(category: 'BOTTOM'),
                                  ),
                                );
                              },
                            ),
                            _buildCategoryButton(
                              icon: Icons.shopping_bag,
                              title: 'SHOES',
                              color: AppColors.accent,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const CategoryPage(category: 'SHOES'),
                                  ),
                                );
                              },
                            ),
                            _buildCategoryButton(
                              icon: Icons.watch,
                              title: 'ACCESSORY',
                              color: AppColors.primary,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const CategoryPage(
                                      category: 'ACCESSORY',
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Recent Products section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.blackTransparent,
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Recent Products',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildProductsGrid(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductsGrid() {
    final productsState = ref.watch(productsNotifierProvider);

    if (productsState.products.isEmpty && productsState.isLoading) {
      return const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (productsState.products.isEmpty && productsState.error != null) {
      return SizedBox(
        height: 200,
        child: Center(
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
        ),
      );
    }

    if (productsState.products.isEmpty) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Text(
            'No more products',
            style: TextStyle(color: AppColors.grey3),
          ),
        ),
      );
    }

    // Use LayoutBuilder to get actual available width dynamically
    return LayoutBuilder(
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
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: crossAxisSpacing,
                mainAxisSpacing: 12,
                childAspectRatio: childAspectRatio,
              ),
              itemCount: productsState.products.length,
              itemBuilder: (context, index) {
                final product = productsState.products[index];
                return _buildProductCard(product);
              },
            ),
            if (productsState.isLoading && productsState.products.isNotEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
          ],
        );
      },
    );
  }

  Widget _buildProductCard(Product product) {
    return ProductCard(product: product);
  }

  Widget _buildCategoryButton({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 70,
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 24, color: color),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
