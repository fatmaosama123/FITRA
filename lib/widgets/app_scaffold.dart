// lib/widgets/app_scaffold.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/profile_controller.dart';
import '../core/constants/colors.dart';
import 'custom_app_bar.dart';
import 'custom_drawer.dart';
import 'bottom_nav_bar.dart';

// Main scaffold widget that wraps all screens with app bar, drawer, and bottom nav
class AppScaffold extends StatelessWidget {
  final Widget body;
  final String? title;
  final bool showMenu;
  final bool showNotification;
  final int notificationCount;
  final int currentNavIndex;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final Widget? leading;
  final bool showNavBar;

  const AppScaffold({
    super.key,
    required this.body,
    this.title,
    this.showMenu = false,
    this.showNotification = true,
    this.notificationCount = 0,
    this.currentNavIndex = -1,
    this.actions,
    this.floatingActionButton,
    this.leading,
    this.showNavBar = true,
  });

  @override
  Widget build(BuildContext context) {
    // Check if dark mode is on
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // Make body extend behind app bar
      extendBodyBehindAppBar: true,
      // Make body extend behind bottom nav
      extendBody: true,

      // Side drawer (hamburger menu) - only if showMenu is true
      drawer: showMenu
          ? Consumer<ProfileController>(
              builder: (context, profileController, child) {
                return CustomDrawer(
                  // Show user info if logged in, else null
                  userName: profileController.isLoggedIn
                      ? profileController.user.name
                      : null,
                  userEmail: profileController.isLoggedIn
                      ? profileController.user.email
                      : null,
                  avatarUrl: profileController.isLoggedIn
                      ? profileController.user.avatarUrl
                      : null,
                  // Go to settings tab (index 4)
                  onSettingsTap: () => _navigateToTab(context, 4),
                  // Show logout confirmation dialog
                  onLogoutTap: () =>
                      profileController.showLogoutDialog(context, isDark),
                );
              },
            )
          : null,

      // Custom app bar at the top
      appBar:
          CustomAppBar(
                title: title,
                showMenu: showMenu,
                showNotification: showNotification,
                notificationCount: notificationCount,
                actions: actions,
                leading: leading,
              )
              as PreferredSizeWidget?,

      // Main screen content
      body: body,

      // Bottom navigation bar - only if showNavBar is true
      bottomNavigationBar: showNavBar
          ? CustomBottomNavBar(
              currentIndex: currentNavIndex,
              onTap: (index) => _onNavTap(context, index),
            )
          : null,

      // Floating action button (if any)
      floatingActionButton: floatingActionButton,
    );
  }

  // Handle bottom nav tap
  void _onNavTap(BuildContext context, int index) {
    // If same tab tapped, do nothing
    if (index == currentNavIndex) return;

    _navigateToTab(context, index);
  }

  // Navigate to a specific tab
  void _navigateToTab(BuildContext context, int index) {
    switch (index) {
      case 0: // HOME tab
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/main',
          // Remove all previous routes
          (route) => false,
          arguments: {'tab': 0},
        );
        break;
      case 1: // SHOP tab
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/main',
          (route) => false,
          arguments: {'tab': 1},
        );
        break;
      case 2: // TRY-ON tab
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/main',
          (route) => false,
          arguments: {'tab': 2},
        );
        break;
      case 3: // CART tab
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/main',
          (route) => false,
          arguments: {'tab': 3},
        );
        break;
      case 4: // PROFILE tab
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/main',
          (route) => false,
          arguments: {'tab': 4},
        );
        break;
    }
  }
}