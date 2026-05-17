// lib/views/category/category_details_screen.dart

import 'package:flutter/material.dart';
import '../../controllers/category_details_controller.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/fonts.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/product_card.dart';

class CategoryDetailsScreen extends StatefulWidget {
  const CategoryDetailsScreen({super.key});

  @override
  State<CategoryDetailsScreen> createState() => _CategoryDetailsScreenState();
}

class _CategoryDetailsScreenState extends State<CategoryDetailsScreen> {
  final controller = CategoryDetailsController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final categoryName =
        ModalRoute.of(context)?.settings.arguments as String? ?? 'Category';
    controller.init(categoryName);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return AppScaffold(
          title: controller.categoryName,
          showMenu: true,
          showNotification: true,
          currentNavIndex: 1, // SHOP tab
          body: Scaffold(
            backgroundColor: bgColor,
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 100), // مساحة للـ AppBar
                  // ✅ عنوان الكاتيجوري
                  Text(
                    'Curated ${controller.categoryName}',
                    style: TextStyle(
                      fontFamily: AppFonts.headline,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.neutral,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ✅ الوصف
                  Text(
                    controller.description,
                    style: TextStyle(
                      fontFamily: AppFonts.body,
                      fontSize: 14,
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.6)
                          : AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ✅ Filter & Sort buttons
                  Row(
                    children: [
                      _buildFilterButton(isDark),
                      const SizedBox(width: 12),
                      _buildSortButton(isDark),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Products
                  if (controller.products.isEmpty)
                    _buildEmptyState(isDark)
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.products.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 24),
                      itemBuilder: (context, index) {
                        return ProductCard(
                          product: controller.products[index],
                          isDark: isDark,
                        );
                      },
                    ),

                  const SizedBox(height: 32),

                  // ✅ Explore More button
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.1)
                            : AppColors.secondary,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.15)
                              : Colors.black.withValues(alpha: 0.05),
                          width: 0.5,
                        ),
                      ),
                      child: Text(
                        'EXPLORE MORE',
                        style: TextStyle(
                          fontFamily: AppFonts.label,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.8)
                              : AppColors.neutral,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterButton(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.08)
            : AppColors.secondary,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.05),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.tune,
            size: 16,
            color: isDark
                ? Colors.white.withValues(alpha: 0.7)
                : AppColors.neutral,
          ),
          const SizedBox(width: 6),
          Text(
            'Filter',
            style: TextStyle(
              fontFamily: AppFonts.label,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.8)
                  : AppColors.neutral,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortButton(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.08)
            : AppColors.secondary,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.05),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.swap_vert,
            size: 16,
            color: isDark
                ? Colors.white.withValues(alpha: 0.7)
                : AppColors.neutral,
          ),
          const SizedBox(width: 6),
          Text(
            'Sort: Newest',
            style: TextStyle(
              fontFamily: AppFonts.label,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.8)
                  : AppColors.neutral,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 64,
            color: isDark
                ? Colors.white.withValues(alpha: 0.3)
                : AppColors.textSecondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No products yet',
            style: TextStyle(
              fontFamily: AppFonts.headline,
              fontSize: 18,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.5)
                  : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
