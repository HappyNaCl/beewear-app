import 'package:beewear_app/data/source/local/token_storage.dart'; // Import this
import 'package:beewear_app/providers/app_startup_provider.dart'; // Import this
import 'package:beewear_app/providers/user_provider.dart';
import 'package:beewear_app/routing/routes.dart';
import 'package:beewear_app/ui/core/layout/main_layout.dart';
import 'package:beewear_app/ui/core/themes/colors.dart';
import 'package:beewear_app/ui/core/ui/product/product_card.dart';
import 'package:beewear_app/ui/profile/view_model/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final profileState = ref.watch(profileViewModelProvider);
    
    // Add TokenStorage to handle logout
    final tokenStorage = ref.read(tokenStorageProvider);

    if (currentUser == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return MainLayout(
      currentIndex: 3, 
      child: Scaffold(
        backgroundColor: Colors.white,
        // ADDED APP BAR WITH LOGOUT
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text("My Profile", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.red),
              onPressed: () async {
                // 1. Clear tokens
                await tokenStorage.clear();

                // 2. Clear user state
                ref.read(currentUserProvider.notifier).clearUser();

                // 3. Reset startup state
                ref.invalidate(appStartupProvider);

                // 4. Go to Landing
                if (context.mounted) {
                  context.go(Routes.landing);
                }
              },
            ),
          ],
        ),
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              // 1. Header Section (Avatar + Name)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      // Avatar
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.primary, width: 3),
                          image: currentUser.profilePicture != null
                              ? DecorationImage(image: NetworkImage(currentUser.profilePicture!), fit: BoxFit.cover)
                              : null,
                        ),
                        child: currentUser.profilePicture == null
                            ? const Icon(Icons.person, size: 60, color: Colors.grey)
                            : null,
                      ),
                      const SizedBox(height: 16),
                      // Name
                      Text(
                        currentUser.username,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        currentUser.email,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 24),

                      // 2. Stats Cards
                      Row(
                        children: [
                          _buildStatCard("Sold", profileState.soldCount.toString(), Colors.green),
                          const SizedBox(width: 16),
                          _buildStatCard("Active", profileState.activeCount.toString(), AppColors.primary),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // 3. Title "My Listings"
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
                  child: Text(
                    "My Listings",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              // 4. Grid of My Products
              profileState.isLoading
                  ? const SliverToBoxAdapter(child: Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator())))
                  : profileState.myProducts.isEmpty
                      ? const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.all(32.0),
                            child: Center(child: Text("You haven't listed anything yet.")),
                          ),
                        )
                      : SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          sliver: SliverGrid(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.7,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final product = profileState.myProducts[index];
                                return GestureDetector(
                                  onTap: () {
                                     context.pushNamed('product_detail', extra: product);
                                  },
                                  child: ProductCard(product: product),
                                );
                              },
                              childCount: profileState.myProducts.length,
                            ),
                          ),
                        ),
              
              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
            ),
            Text(
              label,
              style: TextStyle(color: color, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}