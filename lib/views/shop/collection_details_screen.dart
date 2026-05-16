// lib/views/shop/collection_details_screen.dart

import 'package:flutter/material.dart';
import '../../controllers/category_details_controller.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/fonts.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/product_card.dart';

class CollectionDetailsScreen extends StatefulWidget {
  const CollectionDetailsScreen({super.key});

  @override
  State<CollectionDetailsScreen> createState() =>
      _CollectionDetailsScreenState();
}

class _CollectionDetailsScreenState extends State<CollectionDetailsScreen> {
  final controller = CategoryDetailsController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final title =
        ModalRoute.of(context)?.settings.arguments as String? ?? 'Collection';
    controller.init(title);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: bgColor,
          appBar: CustomAppBar(title: controller.categoryName, showMenu: false),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // ✅ عنوان الكوليكشن - أبيض واضح في الـ Dark
                Text(
                  controller.categoryName,
                  style: TextStyle(
                    fontFamily: AppFonts.headline,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.neutral,
                  ),
                ),

                const SizedBox(height: 8),

                // ✅ الوصف - أبيض مع شفافية أقل عشان يبقى واضح
                Text(
                  controller.description,
                  style: TextStyle(
                    fontFamily: AppFonts.body,
                    fontSize: 14,
                    color: isDark
                        ? Colors.white.withValues(
                            alpha: 0.7,
                          ) // أعلى شوية من 0.6
                        : AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 20),

                // ✅ Filter & Sort - ألوان أكتر تناسق مع الـ Dark
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.1) // أغمق شوية
                            : AppColors.secondary,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.15)
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
                                ? Colors.white.withValues(alpha: 0.8)
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
                                  ? Colors.white.withValues(alpha: 0.9) // أوضح
                                  : AppColors.neutral,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.1)
                            : AppColors.secondary,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.15)
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
                                ? Colors.white.withValues(alpha: 0.8)
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
                                  ? Colors.white.withValues(alpha: 0.9)
                                  : AppColors.neutral,
                            ),
                          ),
                        ],
                      ),
                    ),
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

                // ✅ Explore More Button
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
        );
      },
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.collections_outlined,
            size: 64,
            color: isDark
                ? Colors.white.withValues(alpha: 0.3)
                : AppColors.textSecondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Collection coming soon',
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
