// lib/views/main_layout.dart

// Flutter material package
import 'package:flutter/material.dart';
// Provider for state management
import 'package:provider/provider.dart';
// Screen imports
import 'home/home_screen.dart';
import 'shop/shop_view.dart';
import 'try_on/try_on_screen.dart';
import 'cart/cart_screen.dart';
import 'profile/profile_screen.dart';
// Profile controller
import '../controllers/profile_controller.dart';
// Custom widgets
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/bottom_nav_bar.dart';

// Main layout with bottom navigation
class MainLayout extends StatefulWidget {
  // Initial tab index
  final int initialTab;

  const MainLayout({super.key, this.initialTab = 0});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  // Current selected tab index
  late int _currentIndex;

  // Screens list for each tab
  final List<Widget> _screens = [
    const HomeScreen(),
    const ShopView(),
    const TryOnScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check for tab argument from route
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map && args.containsKey('tab')) {
      final tab = args['tab'] as int;
      if (tab != _currentIndex) {
        setState(() {
          _currentIndex = tab;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // Side drawer with user info
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
            onSettingsTap: () => _onNavTap(4),
            onLogoutTap: () =>
                profileController.showLogoutDialog(context, isDark),
          );
        },
      ),

      // Custom app bar
      appBar: const CustomAppBar(
        showMenu: true,
        showNotification: true,
        notificationCount: 0,
      ),

      // Body with screen switching
      body: IndexedStack(index: _currentIndex, children: _screens),

      // Bottom navigation bar
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }

  // Handle tab change
  void _onNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}