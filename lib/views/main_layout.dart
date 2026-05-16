// lib/views/main_layout.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home/home_screen.dart';
import 'shop/shop_view.dart';
import 'try_on/try_on_screen.dart';
import 'cart/cart_screen.dart';
import 'profile/profile_screen.dart';
import '../controllers/profile_controller.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/bottom_nav_bar.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const ShopView(),
    const TryOnScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // ✅ Drawer الجديد
      drawer: Consumer<ProfileController>(
        builder: (context, profileController, child) {
          return CustomDrawer(
            userName: profileController.isLoggedIn
                ? profileController.user.name
                : null,
            userEmail: profileController.isLoggedIn
                ? profileController.user.email
                : null,
            avatarUrl: profileController.isLoggedIn
                ? profileController.user.avatarUrl
                : null,
            onSettingsTap: () => Navigator.pushNamed(context, '/profile'),
            onLogoutTap: () =>
                profileController.showLogoutDialog(context, isDark),
          );
        },
      ),

      appBar: const CustomAppBar(
        showMenu: true,
        showNotification: true,
        notificationCount: 0,
      ),

      body: _screens[_currentIndex],

      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
