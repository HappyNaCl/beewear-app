import 'package:beewear_app/ui/core/themes/colors.dart';
import 'package:flutter/material.dart';

class CategoryHeader extends StatelessWidget {
  final String category;

  const CategoryHeader({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: AppColors.primary,
        boxShadow: [
          BoxShadow(
            color: AppColors.blackTransparent,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back, color: AppColors.white),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                category,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
