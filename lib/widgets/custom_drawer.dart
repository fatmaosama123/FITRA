// lib/widgets/custom_drawer.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/constants/colors.dart';
import '../core/constants/fonts.dart';

class CustomDrawer extends StatelessWidget {
  final String? userName;
  final String? userEmail;
  final String? avatarUrl;
  final VoidCallback? onProfileTap;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onLogoutTap;

  const CustomDrawer({
    super.key,
    this.userName,
    this.userEmail,
    this.avatarUrl,
    this.onProfileTap,
    this.onSettingsTap,
    this.onLogoutTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        // ✅ نفس الكيرف بتاع الـ AppBar
        borderRadius: const BorderRadius.horizontal(right: Radius.circular(24)),
        child: BackdropFilter(
          // ✅ نفس الـ blur بتاع الـ AppBar
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              // ✅ نفس لون الـ AppBar (شفاف)
              color: isDark
                  ? Colors.black.withValues(alpha: 0.3)
                  : Colors.white.withValues(alpha: 0.7),
              // ✅ border خفيف من اليمين زي الـ AppBar
              border: Border(
                right: BorderSide(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.05)
                      : Colors.black.withValues(alpha: 0.05),
                  width: 0.5,
                ),
              ),
              // ✅ شادو من اليمين زي الـ BottomNav
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.15)
                      : Colors.black.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(4, 0),
                  spreadRadius: -2,
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // ✅ Header أصغر ومتقدم لفوق
                  _buildHeader(context, isDark),

                  const SizedBox(height: 16),

                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: [
                        _buildMenuItem(
                          icon: Icons.home_outlined,
                          title: 'Home',
                          isDark: isDark,
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/main',
                              (route) => false,
                            );
                          },
                        ),
                        _buildMenuItem(
                          icon: Icons.shopping_bag_outlined,
                          title: 'Shop',
                          isDark: isDark,
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/category-details');
                          },
                        ),
                        _buildMenuItem(
                          icon: Icons.favorite_outline,
                          title: 'Wishlist',
                          isDark: isDark,
                          onTap: () {
                            Navigator.pop(context);
                            // TODO: Navigate to wishlist
                          },
                        ),
                        _buildMenuItem(
                          icon: Icons.shopping_cart_outlined,
                          title: 'Cart',
                          isDark: isDark,
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/cart');
                          },
                        ),
                        _buildMenuItem(
                          icon: Icons.person_outline,
                          title: 'Profile',
                          isDark: isDark,
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/profile');
                          },
                        ),
                        const Divider(height: 24),
                        _buildMenuItem(
                          icon: Icons.settings_outlined,
                          title: 'Settings',
                          isDark: isDark,
                          onTap: () {
                            Navigator.pop(context);
                            onSettingsTap?.call();
                          },
                        ),
                        _buildMenuItem(
                          icon: Icons.help_outline,
                          title: 'Help Center',
                          isDark: isDark,
                          onTap: () {
                            Navigator.pop(context);
                            // TODO: Navigate to help
                          },
                        ),
                      ],
                    ),
                  ),

                  // ✅ Log Out Button أكتر بروفيشنال
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        onLogoutTap?.call();
                      },
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.5),
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.logout,
                                color: AppColors.primary,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Log Out',
                                style: TextStyle(
                                  fontFamily: AppFonts.label,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ✅ Header أصغر وأكتر بروفيشنال
  Widget _buildHeader(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      child: Column(
        children: [
          // ✅ زرار Close أصغر وأخف
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.06)
                      : Colors.black.withValues(alpha: 0.04),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  color: isDark ? Colors.white60 : Colors.black45,
                  size: 18,
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // ✅ Avatar أصغر (70×70)
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: ClipOval(
              child: avatarUrl != null
                  ? Image.network(
                      avatarUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildDefaultAvatar(isDark);
                      },
                    )
                  : _buildDefaultAvatar(isDark),
            ),
          ),

          const SizedBox(height: 12),

          // ✅ الاسم أصغر
          Text(
            userName ?? 'Guest User',
            style: TextStyle(
              fontFamily: AppFonts.headline,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),

          const SizedBox(height: 2),

          // ✅ الإيميل أصغر وأخف
          Text(
            userEmail ?? 'guest@fitra.com',
            style: TextStyle(
              fontFamily: AppFonts.body,
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar(bool isDark) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
      ),
      child: Center(
        child: Text(
          (userName ?? 'G')[0].toUpperCase(),
          style: const TextStyle(
            fontFamily: AppFonts.headline,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // ✅ Menu items أكتر بروفيشنال
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          // ✅ ألوان أخف وأكتر تناسق
          color: isDark
              ? Colors.white.withValues(alpha: 0.04)
              : Colors.black.withValues(alpha: 0.02),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            // ✅ Icon container أصغر وأخف
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.primary.withValues(alpha: 0.12)
                    : AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.primary, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: AppFonts.headline,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.25)
                  : Colors.black.withValues(alpha: 0.15),
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}
