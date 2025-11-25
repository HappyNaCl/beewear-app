import 'package:beewear_app/ui/core/ui/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class MainLayout extends StatefulWidget {
  final Widget child;
  final int currentIndex;

  const MainLayout({super.key, required this.child, this.currentIndex = 0});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  late int _currentNavIndex;

  @override
  void initState() {
    super.initState();
    _currentNavIndex = widget.currentIndex;
  }

  void _handleNavTap(int index) {
    setState(() {
      _currentNavIndex = index;
    });

    // Handle navigation based on index
    if (!mounted) return;

    switch (index) {
      case 0:
        // Home - pop to root if not already there
        Navigator.of(context).popUntil((route) => route.isFirst);
        break;
      case 1:
        // Search - TODO: Navigate to search screen
        break;
      case 2:
        // Cart - TODO: Navigate to cart screen
        break;
      case 3:
        // Profile - TODO: Navigate to profile screen
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentNavIndex,
        onTap: _handleNavTap,
      ),
    );
  }
}
