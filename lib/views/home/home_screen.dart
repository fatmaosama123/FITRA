// lib/views/home/home_screen.dart

import 'package:flutter/material.dart';
import '../../controllers/home_controller.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/fonts.dart';
import '../../routes/app_routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = HomeController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: bgColor,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // Search Bar
                _buildSearchBar(isDark),

                const SizedBox(height: 20),

                // Categories
                _buildCategories(isDark),

                const SizedBox(height: 28),

                // Trending Section
                _buildTrendingSection(isDark),

                const SizedBox(height: 32),

                // New Arrivals Section
                _buildNewArrivalsSection(isDark),

                const SizedBox(height: 32),

                // Join Club Section
                _buildJoinClubSection(isDark),

                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchBar(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : AppColors.secondary.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.black.withValues(alpha: 0.05),
            width: 0.5,
          ),
        ),
        child: TextField(
          onChanged: controller.updateSearch,
          style: TextStyle(color: isDark ? Colors.white : AppColors.neutral),
          decoration: InputDecoration(
            hintText: 'Search for your style...',
            hintStyle: TextStyle(
              fontFamily: AppFonts.body,
              fontSize: 14,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.4)
                  : AppColors.textSecondary,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.5)
                  : AppColors.textSecondary,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategories(bool isDark) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: controller.categories.length,
        itemBuilder: (context, index) {
          final isSelected = controller.selectedCategoryIndex == index;
          final category = controller.categories[index];

          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => controller.selectCategory(index, context),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.tertiary
                      : isDark
                      ? Colors.white.withValues(alpha: 0.06)
                      : AppColors.secondary,
                  borderRadius: BorderRadius.circular(20),
                  border: isSelected
                      ? null
                      : Border.all(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.05)
                              : Colors.black.withValues(alpha: 0.05),
                          width: 0.5,
                        ),
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    fontFamily: AppFonts.label,
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? AppColors.white
                        : isDark
                        ? Colors.white.withValues(alpha: 0.8)
                        : AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTrendingSection(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CURATION 01',
                    style: TextStyle(
                      fontFamily: AppFonts.label,
                      fontSize: 10,
                      letterSpacing: 2,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Trending Now',
                    style: TextStyle(
                      fontFamily: AppFonts.headline,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.neutral,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    Text(
                      'View collection',
                      style: TextStyle(
                        fontFamily: AppFonts.body,
                        fontSize: 12,
                        color: AppColors.primary,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.trendingProducts.length,
              itemBuilder: (context, index) {
                return controller.buildProductCard(
                  controller.trendingProducts[index],
                  isHorizontal: true,
                  isDark: isDark,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewArrivalsSection(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'LATEST DROP',
            style: TextStyle(
              fontFamily: AppFonts.label,
              fontSize: 10,
              letterSpacing: 2,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'New Arrivals',
            style: TextStyle(
              fontFamily: AppFonts.headline,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.neutral,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.6,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: controller.newArrivals.length,
            itemBuilder: (context, index) {
              return controller.buildProductCard(
                controller.newArrivals[index],
                isDark: isDark,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildJoinClubSection(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : AppColors.secondary,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.black.withValues(alpha: 0.05),
            width: 0.5,
          ),
        ),
        child: Column(
          children: [
            Text(
              'Join the FITRA Club',
              style: TextStyle(
                fontFamily: AppFonts.headline,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.neutral,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Sign up for early access to drops and exclusive curated styling guides.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppFonts.body,
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : AppColors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.05)
                      : Colors.black.withValues(alpha: 0.05),
                  width: 0.5,
                ),
              ),
              child: TextField(
                controller: controller.emailController,
                style: TextStyle(
                  color: isDark ? Colors.white : AppColors.neutral,
                ),
                decoration: InputDecoration(
                  hintText: 'Email address',
                  hintStyle: TextStyle(
                    fontFamily: AppFonts.body,
                    fontSize: 14,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.4)
                        : AppColors.textSecondary,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: controller.subscribeEmail,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : AppColors.neutral,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  'Join Now',
                  style: TextStyle(
                    fontFamily: AppFonts.label,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
