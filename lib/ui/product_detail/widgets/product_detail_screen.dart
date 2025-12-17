import 'package:beewear_app/domain/models/product.dart';
import 'package:beewear_app/providers/user_provider.dart';
import 'package:beewear_app/ui/core/themes/colors.dart';
import 'package:beewear_app/ui/home/view_model/products_notifier.dart';
import 'package:beewear_app/ui/product_detail/view_model/product_detail_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ProductDetailScreen extends ConsumerWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider); 
    
    // 2. Check Ownership (Safe check for null)
    final bool isMyProduct = currentUser != null && currentUser.userId == product.creatorId;

    final state = ref.watch(productDetailViewModelProvider);
    final viewModel = ref.read(productDetailViewModelProvider.notifier);
    final formatCurrency = NumberFormat.simpleCurrency(locale: 'id_ID', name: 'Rp ');

    // Listen for success (Delete or Add Cart)
    ref.listen(productDetailViewModelProvider, (prev, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!), backgroundColor: Colors.red),
        );
      }
      
      if (next.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text(next.successMessage ?? "Success!"), backgroundColor: Colors.green),
        );
        
        if (isMyProduct) {
          // If we just deleted the item, go back to home and refresh list
          ref.read(productsNotifierProvider.notifier).refresh();
          context.pop();
        }
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // IMAGE SECTION WITH STATUS BADGE
                  Stack(
                    children: [
                      // 1. The Image
                      Container(
                        height: 300,
                        width: double.infinity,
                        color: AppColors.grey1,
                        child: product.imageUrl.isNotEmpty
                            ? Image.network(product.imageUrl, fit: BoxFit.cover)
                            : const Center(child: Icon(Icons.image_not_supported, size: 50)),
                      ),
                      
                      // 2. The Status Badge (Top Right)
                      Positioned(
                        top: 16,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: product.status == 'ACTIVE' ? Colors.green : Colors.grey,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))
                            ],
                          ),
                          child: Text(
                            product.status, // e.g. "ACTIVE" or "SOLD"
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Price & Name
                        Text(
                          formatCurrency.format(product.price),
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: AppColors.primary, fontWeight: FontWeight.bold
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(product.name, style: Theme.of(context).textTheme.headlineSmall),
                        const SizedBox(height: 16),
                        
                        // Metadata Chips (REMOVED STATUS FROM HERE)
                        Wrap(
                          spacing: 8,
                          children: [
                            Chip(
                              avatar: const Icon(Icons.category, size: 16),
                              label: Text(product.category),
                            ),
                            Chip(
                              avatar: const Icon(Icons.person, size: 16),
                              label: Text(product.gender),
                            ),
                            // Status is gone from here!
                          ],
                        ),
                        const SizedBox(height: 24),
                        
                        // Description
                        const Text("Description", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        const SizedBox(height: 8),
                        
                        // Fix for "No description provided"
                        // If description is actually empty string in DB, show a placeholder.
                        Text(
                          (product.description.isEmpty || product.description == "null") 
                              ? "No description provided." 
                              : product.description,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          
          // Bottom Button Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0,-2))],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: isMyProduct
                    ? ElevatedButton(
                        onPressed: state.isLoading ? null : () => viewModel.deleteProduct(product.id),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                        child: state.isLoading 
                            ? const CircularProgressIndicator(color: Colors.white) 
                            : const Text("Delete Listing"),
                      )
                    : ElevatedButton(
                        onPressed: state.isLoading ? null : () => viewModel.addToCart(product.id),
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                        child: state.isLoading 
                            ? const CircularProgressIndicator(color: Colors.white) 
                            : const Text("Add to Cart"),
                      ),
              ),
            ),
          )
        ],
      ),
    );
  }
}