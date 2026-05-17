// lib/widgets/app_scaffold.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/profile_controller.dart';
import '../core/constants/colors.dart';
import 'custom_app_bar.dart';
import 'custom_drawer.dart';
import 'bottom_nav_bar.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,

      drawer: showMenu
          ? Consumer<ProfileController>(
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
                  onSettingsTap: () => _navigateToTab(context, 4),
                  onLogoutTap: () =>
                      profileController.showLogoutDialog(context, isDark),
                );
              },
            )
          : null,

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

      body: body,

      bottomNavigationBar: showNavBar
          ? CustomBottomNavBar(
              currentIndex: currentNavIndex,
              onTap: (index) => _onNavTap(context, index),
            )
          : null,

      floatingActionButton: floatingActionButton,
    );
  }

  void _onNavTap(BuildContext context, int index) {
    // لو في نفس التاب، مفيش حاجة
    if (index == currentNavIndex) return;

    _navigateToTab(context, index);
  }

  void _navigateToTab(BuildContext context, int index) {
    switch (index) {
      case 0: // HOME
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/main',
          (route) => false,
          arguments: {'tab': 0},
        );
        break;
      case 1: // SHOP
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/main',
          (route) => false,
          arguments: {'tab': 1},
        );
        break;
      case 2: // TRY-ON
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/main',
          (route) => false,
          arguments: {'tab': 2},
        );
        break;
      case 3: // CART
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/main',
          (route) => false,
          arguments: {'tab': 3},
        );
        break;
      case 4: // PROFILE
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
