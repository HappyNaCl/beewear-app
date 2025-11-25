import 'package:beewear_app/domain/models/product.dart';
import 'package:beewear_app/ui/core/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  String _formatPrice(double price) {
    final formatter = NumberFormat('#,###', 'id_ID');
    return 'Rp ${formatter.format(price.toInt())}';
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        color: AppColors.grey1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image (square)
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                color: AppColors.white,
                child: product.imageUrl != null
                    ? Image.network(
                        product.imageUrl!,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                  : null,
                              color: AppColors.primary,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Icon(
                              Icons.shopping_bag,
                              size: 48,
                              color: AppColors.grey3,
                            ),
                          );
                        },
                      )
                    : const Center(child: Icon(Icons.shopping_bag, size: 48)),
              ),
            ),

            // Product Info (fixed height)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 88,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          product.category,
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.grey3,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      _formatPrice(product.price),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
