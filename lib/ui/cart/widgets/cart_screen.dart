import 'package:beewear_app/ui/core/layout/main_layout.dart';
import 'package:beewear_app/ui/core/themes/colors.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentIndex: 2, // Highlight "Cart" tab
      child: Scaffold(
        appBar: AppBar(
          title: const Text("My Cart", style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          automaticallyImplyLeading: false, // Hide back button
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_cart_outlined, size: 64, color: AppColors.grey3),
              const SizedBox(height: 16),
              Text(
                "Your cart is empty",
                style: TextStyle(color: AppColors.grey3, fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}