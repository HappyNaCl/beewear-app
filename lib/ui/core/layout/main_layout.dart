import 'package:beewear_app/routing/routes.dart'; // Import Routes
import 'package:beewear_app/ui/core/ui/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Import GoRouter
class MainLayout extends StatefulWidget {
  final Widget child;
  final int currentIndex;

  const MainLayout({super.key, required this.child, this.currentIndex = 0});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  // late int _currentNavIndex;

  // @override
  // void initState() {
  //   super.initState();
  //   _currentNavIndex = widget.currentIndex;
  // }

  void _handleNavTap(int index) {
    if (index == widget.currentIndex) return; // Don't reload current page

    switch (index) {
      case 0:
        context.go(Routes.home);
        break;
      case 1:
        context.go(Routes.addProduct);
        break;
      case 2:
        context.go(Routes.cart);
        break;
      case 3:
        context.go(Routes.authorized); // Using AuthorizedScreen as Profile
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavBar(
        currentIndex: widget.currentIndex,
        onTap: _handleNavTap,
      ),
    );
  }
}
