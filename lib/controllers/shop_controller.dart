// lib/controllers/shop_controller.dart

import 'dart:async';
import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import '../core/constants/colors.dart';
import '../core/constants/fonts.dart';
import '../routes/app_routes.dart';

class ShopController extends ChangeNotifier {
  // ─── Data Getters ───
  List<CategoryModel> get categories => CategoryModel.allCategories;
  List<Map<String, String>> get seasonalEdits => CategoryModel.seasonalEdits;

  // ─── Navigation ───
  void openCategory(BuildContext context, CategoryModel category) {
    AppRoutes.goToCategoryDetails(context, category.name);
  }

  void openCollectionDetails(BuildContext context, String title) {
    AppRoutes.goToCollectionDetails(context, title);
  }

  // ─── Category Card with Carousel ───
  Widget buildCategoryCard(
    CategoryModel category,
    BuildContext context,
    bool isDark,
  ) {
    return GestureDetector(
      onTap: () => openCategory(context, category),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : category.backgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: isDark
              ? Border.all(
                  color: Colors.white.withValues(alpha: 0.05),
                  width: 0.5,
                )
              : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Image carousel (multiple images auto-sliding)
              _buildImageCarousel(category, isDark),
              // Bottom gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      isDark
                          ? Colors.black.withValues(alpha: 0.85)
                          : category.backgroundColor.withValues(alpha: 0.85),
                    ],
                  ),
                ),
              ),
              // Category info text
              _buildCategoryInfo(category, isDark),
            ],
          ),
        ),
      ),
    );
  }

  // Build image carousel for category card
  Widget _buildImageCarousel(CategoryModel category, bool isDark) {
    // If only 1 image, show static
    if (category.imageUrls.length == 1) {
      return _buildImage(category.imageUrls[0], category, isDark);
    }

    // Multiple images with auto-slide
    return _CategoryImageCarousel(category: category, isDark: isDark);
  }

  // Single image builder
  Widget _buildImage(String url, CategoryModel category, bool isDark) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : category.backgroundColor,
          child: const Center(
            child: CircularProgressIndicator(color: Colors.white54),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : category.backgroundColor,
          child: Center(
            child: Icon(
              Icons.image_not_supported,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.3)
                  : category.textColor.withValues(alpha: 0.5),
              size: 40,
            ),
          ),
        );
      },
    );
  }

  // Category info overlay
  Widget _buildCategoryInfo(CategoryModel category, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (category.title.isNotEmpty)
            Text(
              category.title,
              style: _textStyle(
                AppFonts.label,
                10,
                isDark
                    ? Colors.white.withValues(alpha: 0.7)
                    : category.textColor.withValues(alpha: 0.7),
              ),
            ),
          if (category.title.isNotEmpty) const SizedBox(height: 4),
          Text(
            category.subtitle,
            style: _textStyle(
              AppFonts.headline,
              24,
              isDark ? Colors.white : category.textColor,
              bold: true,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            category.description,
            style: _textStyle(
              AppFonts.body,
              12,
              isDark
                  ? Colors.white.withValues(alpha: 0.8)
                  : category.textColor.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 12),
          // Arrow button
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_forward,
              color: isDark ? Colors.white : AppColors.neutral,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Seasonal Edit Tile ───
  Widget buildSeasonalEditTile(
    Map<String, String> edit,
    BuildContext context,
    bool isDark,
  ) {
    return GestureDetector(
      onTap: () => openCollectionDetails(context, edit['title']!),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Text(
              edit['number']!,
              style: _textStyle(
                AppFonts.headline,
                24,
                isDark
                    ? Colors.white.withValues(alpha: 0.15)
                    : AppColors.secondaryDark,
                bold: true,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                edit['title']!,
                style: _textStyle(
                  AppFonts.headline,
                  16,
                  isDark
                      ? Colors.white.withValues(alpha: 0.5)
                      : AppColors.neutral,
                  bold: true,
                ),
              ),
            ),
            Icon(Icons.arrow_forward, color: AppColors.primary, size: 20),
          ],
        ),
      ),
    );
  }

  // ─── Text Style Helper ───
  TextStyle _textStyle(
    String font,
    double size,
    Color color, {
    bool bold = false,
  }) =>
      TextStyle(
        fontFamily: font,
        fontSize: size,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        color: color,
        letterSpacing: font == AppFonts.label ? 1.5 : 0,
      );
}

// ─── Stateful Carousel Widget ───
class _CategoryImageCarousel extends StatefulWidget {
  final CategoryModel category;
  final bool isDark;

  const _CategoryImageCarousel({
    required this.category,
    required this.isDark,
  });

  @override
  State<_CategoryImageCarousel> createState() => _CategoryImageCarouselState();
}

class _CategoryImageCarouselState extends State<_CategoryImageCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!_pageController.hasClients) return;
      final next = (_currentPage + 1) % widget.category.imageUrls.length;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        PageView.builder(
          controller: _pageController,
          onPageChanged: (index) => setState(() => _currentPage = index),
          itemCount: widget.category.imageUrls.length,
          itemBuilder: (context, index) => Image.network(
            widget.category.imageUrls[index],
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                color: widget.isDark
                    ? Colors.white.withValues(alpha: 0.06)
                    : widget.category.backgroundColor,
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white54),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: widget.isDark
                    ? Colors.white.withValues(alpha: 0.06)
                    : widget.category.backgroundColor,
                child: Center(
                  child: Icon(
                    Icons.image_not_supported,
                    color: widget.isDark
                        ? Colors.white.withValues(alpha: 0.3)
                        : widget.category.textColor.withValues(alpha: 0.5),
                    size: 40,
                  ),
                ),
              );
            },
          ),
        ),
        // Page indicators
        Positioned(
          top: 16,
          right: 16,
          child: Row(
            children: List.generate(widget.category.imageUrls.length, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.only(left: 6),
                width: _currentPage == index ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}