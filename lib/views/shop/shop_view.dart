// lib/views/shop/shop_view.dart

import 'package:flutter/material.dart';
import '../../controllers/shop_controller.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/fonts.dart';

class ShopView extends StatelessWidget {
  const ShopView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ShopController();
    final categories = controller.categories;
    final seasonalEdits = controller.seasonalEdits;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            Text(
              'CURATED COLLECTIONS',
              style: TextStyle(
                fontFamily: AppFonts.label,
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
                letterSpacing: 1.5,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Explore\nCategories',
              style: TextStyle(
                fontFamily: AppFonts.headline,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.neutral,
                height: 1.1,
              ),
            ),

            const SizedBox(height: 24),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categories.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                return controller.buildCategoryCard(
                  categories[index],
                  context,
                  isDark,
                );
              },
            ),

            const SizedBox(height: 32),

            Text(
              'Seasonal Edits',
              style: TextStyle(
                fontFamily: AppFonts.headline,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.neutral,
              ),
            ),

            const SizedBox(height: 16),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: seasonalEdits.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : AppColors.neutral.withValues(alpha: 0.1),
              ),
              itemBuilder: (context, index) {
                return controller.buildSeasonalEditTile(
                  seasonalEdits[index],
                  context,
                  isDark,
                );
              },
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
