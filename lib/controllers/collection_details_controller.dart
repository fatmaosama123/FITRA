// lib/controllers/collection_details_controller.dart

import 'dart:async';
import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';
import '../core/constants/colors.dart';
import '../core/constants/fonts.dart';
import '../widgets/product_card.dart';

class CollectionDetailsController extends ChangeNotifier {
  String categoryName = '';
  String description = '';
  List<ProductModel> products = [];
  bool isLoading = true;

  int currentImageIndex = 0;
  Timer? _imageTimer;
  final PageController imagePageController = PageController();

  void init(String title) {
    categoryName = title;
    description =
        'Curated $title collection. Minimal aesthetics, maximum durability. Designed for the tactile curator.';
    
    Future.delayed(const Duration(milliseconds: 500), () {
      products = ProductModel.getByCategory(title);
      isLoading = false;
      notifyListeners();
    });

    notifyListeners();
  }

  @override
  void dispose() {
    _imageTimer?.cancel();
    imagePageController.dispose();
    super.dispose();
  }

  // ─── UI BUILDERS ───

  Widget buildHeader(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        _text(
          categoryName,
          AppFonts.headline,
          28,
          isDark ? Colors.white : AppColors.neutral,
          bold: true,
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: _textStyle(
            AppFonts.body,
            14,
            isDark ? Colors.white.withValues(alpha: 0.7) : AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 20),
        _buildImageCarousel(isDark),
        const SizedBox(height: 20),
        _buildFilterSortButtons(isDark),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildImageCarousel(bool isDark) {
    final category = CategoryModel.allCategories.firstWhere(
      (c) => c.name.toLowerCase() == categoryName.toLowerCase(),
      orElse: () => CategoryModel.allCategories.first,
    );

    if (category.imageUrls.length == 1) {
      return _buildSingleImage(category.imageUrls[0], category, isDark);
    }

    return _buildMultiImageCarousel(category, isDark);
  }

  Widget _buildSingleImage(String url, CategoryModel category, bool isDark) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.network(
        url,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          height: 200,
          color: category.backgroundColor,
          child: Icon(Icons.image_not_supported, color: category.textColor),
        ),
      ),
    );
  }

  Widget _buildMultiImageCarousel(CategoryModel category, bool isDark) {
    _startImageTimer(category);

    return Container(
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            PageView.builder(
              controller: imagePageController,
              onPageChanged: (index) {
                currentImageIndex = index;
                notifyListeners();
              },
              itemCount: category.imageUrls.length,
              itemBuilder: (context, index) => Image.network(
                category.imageUrls[index],
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: category.backgroundColor,
                  child: Icon(Icons.image_not_supported, color: category.textColor),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.5),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.6],
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 20,
              child: Text(
                categoryName,
                style: _textStyle(AppFonts.headline, 22, Colors.white, bold: true),
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: Row(
                children: List.generate(category.imageUrls.length, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(left: 6),
                    width: currentImageIndex == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: currentImageIndex == index
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startImageTimer(CategoryModel category) {
    _imageTimer?.cancel();
    if (category.imageUrls.length <= 1) return;
    
    _imageTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!imagePageController.hasClients) return;
      final next = (currentImageIndex + 1) % category.imageUrls.length;
      imagePageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  Widget _buildFilterSortButtons(bool isDark) {
    return Row(
      children: [
        _actionButton(
          icon: Icons.tune,
          label: 'Filter',
          isDark: isDark,
          onTap: () {},
        ),
        const SizedBox(width: 12),
        _actionButton(
          icon: Icons.swap_vert,
          label: 'Sort: Newest',
          isDark: isDark,
          onTap: () {},
        ),
      ],
    );
  }

  Widget buildProducts(bool isDark) {
    if (isLoading) {
      return _buildLoadingState(isDark);
    }
    if (products.isEmpty) {
      return _buildEmptyState(isDark);
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      separatorBuilder: (_, __) => const SizedBox(height: 24),
      itemBuilder: (_, index) => ProductCard(
        product: products[index],
        isDark: isDark,
      ),
    );
  }

  Widget _buildLoadingState(bool isDark) => Center(
        child: Column(
          children: [
            const SizedBox(height: 40),
            CircularProgressIndicator(color: AppColors.primary),
            const SizedBox(height: 16),
            _text('Loading collection...', AppFonts.body, 14,
                isDark ? Colors.white70 : AppColors.textSecondary),
          ],
        ),
      );

  Widget _buildEmptyState(bool isDark) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Icon(
              Icons.collections_outlined,
              size: 64,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.3)
                  : AppColors.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            _text(
              'Collection coming soon',
              AppFonts.headline,
              18,
              isDark ? Colors.white.withValues(alpha: 0.5) : AppColors.textSecondary,
            ),
          ],
        ),
      );

  // FIXED: Removed AppRoutes.goToShop, use callback instead
  Widget buildExploreButton(bool isDark, VoidCallback onTap) => Center(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
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
            child: _text(
              'EXPLORE MORE',
              AppFonts.label,
              12,
              isDark ? Colors.white.withValues(alpha: 0.8) : AppColors.neutral,
              bold: true,
            ),
          ),
        ),
      );

  // ─── PRIVATE HELPERS ───

  Widget _actionButton({
    required IconData icon,
    required String label,
    required bool isDark,
    required VoidCallback onTap,
  }) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                icon,
                size: 16,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.8)
                    : AppColors.neutral,
              ),
              const SizedBox(width: 6),
              _text(label, AppFonts.label, 13,
                  isDark ? Colors.white.withValues(alpha: 0.9) : AppColors.neutral,
                  bold: true),
            ],
          ),
        ),
      );

  Widget _text(String text, String font, double size, Color color,
          {bool bold = false}) =>
      Text(
        text,
        style: _textStyle(font, size, color, bold: bold),
      );

  TextStyle _textStyle(String font, double size, Color color,
          {bool bold = false}) =>
      TextStyle(
        fontFamily: font,
        fontSize: size,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        color: color,
      );
}