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

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // Section label
            _sectionLabel('CURATED COLLECTIONS'),
            const SizedBox(height: 8),
            // Page title
            _pageTitle(isDark),
            const SizedBox(height: 24),
            // Categories list with carousel
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) => controller.buildCategoryCard(
                categories[index],
                context,
                isDark,
              ),
            ),
            const SizedBox(height: 32),
            // Seasonal edits section
            _sectionTitle('Seasonal Edits', isDark),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: seasonalEdits.length,
              separatorBuilder: (_, __) => Divider(
                height: 1,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : AppColors.neutral.withValues(alpha: 0.1),
              ),
              itemBuilder: (context, index) => controller.buildSeasonalEditTile(
                seasonalEdits[index],
                context,
                isDark,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Section label (small colored text)
  Widget _sectionLabel(String text) => Text(
        text,
        style: TextStyle(
          fontFamily: AppFonts.label,
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
          letterSpacing: 1.5,
        ),
      );

  // Page title
  Widget _pageTitle(bool isDark) => Text(
        'Explore\nCategories',
        style: TextStyle(
          fontFamily: AppFonts.headline,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : AppColors.neutral,
          height: 1.1,
        ),
      );

  // Section title
  Widget _sectionTitle(String text, bool isDark) => Text(
        text,
        style: TextStyle(
          fontFamily: AppFonts.headline,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : AppColors.neutral,
        ),
      );
}