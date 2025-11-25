import 'package:beewear_app/ui/core/themes/colors.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? hintText;

  const SearchBar({super.key, this.onChanged, this.onSubmitted, this.hintText});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackTransparent,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.grey1,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: hintText ?? 'Search...',
                  prefixIcon: Icon(Icons.search, color: AppColors.grey3),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                onChanged: onChanged,
                onSubmitted: onSubmitted,
              ),
            ),
          ),
          // Placeholder for settings or filter button
          const SizedBox(width: 12),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.tune, color: AppColors.grey3),
          ),
        ],
      ),
    );
  }
}
