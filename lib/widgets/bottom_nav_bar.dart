// lib/widgets/bottom_nav_bar.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/constants/colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.white.withValues(alpha: 0.7),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.15)
                    : Colors.black.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, -4),
                spreadRadius: -2,
              ),
            ],
            border: Border(
              top: BorderSide(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.black.withValues(alpha: 0.05),
                width: 0.5,
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(context, Icons.home_outlined, 'HOME', 0),
                  _buildNavItem(context, Icons.grid_view_outlined, 'SHOP', 1),
                  _buildNavItem(
                    context,
                    Icons.face_retouching_natural,
                    'TRY-ON',
                    2,
                    isSpecial: true,
                  ),
                  _buildNavItem(
                    context,
                    Icons.shopping_cart_outlined,
                    'CART',
                    3,
                    hasBadge: true,
                  ),
                  _buildNavItem(context, Icons.person_outline, 'PROFILE', 4),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, // ✅ أضفت context هنا
    IconData icon,
    String label,
    int index, {
    bool isSpecial = false,
    bool hasBadge = false,
  }) {
    final isSelected = currentIndex == index;
    final isDark =
        Theme.of(context).brightness == Brightness.dark; // ✅ دلوقتي يشتغل

    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isSelected
                  ? (isSpecial
                        ? AppColors.tertiary.withValues(alpha: 0.9)
                        : AppColors.primary.withValues(alpha: 0.9))
                  : Colors.transparent,
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.2)
                          : Colors.white.withValues(alpha: 0.5),
                      width: 1,
                    )
                  : null,
            ),
            child: Stack(
              children: [
                Icon(
                  icon,
                  color: isSelected
                      ? AppColors.white
                      : (isDark
                            ? Colors.white.withValues(alpha: 0.6)
                            : Colors.black.withValues(alpha: 0.4)),
                  size: 24,
                ),
                if (hasBadge && isSelected)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? AppColors.primary
                  : (isDark
                        ? Colors.white.withValues(alpha: 0.6)
                        : Colors.black.withValues(alpha: 0.4)),
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
