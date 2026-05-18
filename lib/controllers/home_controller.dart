// lib/controllers/home_controller.dart

import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../core/constants/colors.dart';
import '../core/constants/fonts.dart';
import '../routes/app_routes.dart';

// Manages home screen state and UI builders
class HomeController extends ChangeNotifier {

  // ─── Categories ───

  // Product category names
  final List<String> categories = [
    'All Essentials',
    'Loungewear',
    'Denim',
    'Accessories',
    'Shoes',
  ];

  // Currently selected category index
  int selectedCategoryIndex = 0;

  // ─── Products ───

  // New arrivals from ProductModel
  List<ProductModel> get newArrivals => ProductModel.newArrivals;
  // Trending products from ProductModel
  List<ProductModel> get trendingProducts => ProductModel.trending;

  // ─── Search ───

  // Current search text
  String searchQuery = '';

  // ─── Email Subscription ───

  // Email input controller
  final emailController = TextEditingController();

  // Select category and navigate to details
  void selectCategory(int index, BuildContext context) {
    selectedCategoryIndex = index;
    notifyListeners();
    // Go to category page
    AppRoutes.goToCategoryDetails(context, categories[index]);
  }

  // Update search query
  void updateSearch(String query) {
    searchQuery = query;
    notifyListeners();
  }

  // Subscribe email (mock)
  void subscribeEmail() {
    debugPrint('Subscribing email: ${emailController.text}');
    emailController.clear();
    notifyListeners();
  }

  // ─── UI BUILDERS ───

  // Build search bar
  Widget buildSearchBar(bool isDark, Function(String) onChanged) => Padding(
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
            onChanged: onChanged,
            style: TextStyle(color: isDark ? Colors.white : AppColors.neutral),
            decoration: InputDecoration(
              hintText: 'Search for your style...',
              hintStyle: _textStyle(AppFonts.body, 14,
                  isDark ? Colors.white.withValues(alpha: 0.4) : AppColors.textSecondary),
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

  // Build categories horizontal list
  Widget buildCategories(bool isDark, BuildContext context) => SizedBox(
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final isSelected = selectedCategoryIndex == index;
            final category = categories[index];
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: GestureDetector(
                onTap: () => selectCategory(index, context),
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
                    style: _textStyle(
                      AppFonts.label,
                      12,
                      isSelected
                          ? AppColors.white
                          : isDark
                              ? Colors.white.withValues(alpha: 0.8)
                              : AppColors.textPrimary,
                      bold: isSelected,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );

  // Build trending products section
  Widget buildTrendingSection(bool isDark, BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section label
                    _text('CURATION 01', AppFonts.label, 10,
                        AppColors.textSecondary,
                        letterSpacing: 2),
                    const SizedBox(height: 4),
                    // Section title
                    _text('Trending Now', AppFonts.headline, 24,
                        isDark ? Colors.white : AppColors.neutral,
                        bold: true),
                  ],
                ),
                // View collection link
                _viewCollectionLink(),
              ],
            ),
            const SizedBox(height: 16),
            // Horizontal products list
            SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: trendingProducts.length,
                itemBuilder: (context, index) => buildProductCard(
                  trendingProducts[index],
                  isHorizontal: true,
                  isDark: isDark,
                  context: context,
                ),
              ),
            ),
          ],
        ),
      );

  // Build new arrivals section
  Widget buildNewArrivalsSection(bool isDark, BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section label
            _text('LATEST DROP', AppFonts.label, 10, AppColors.primary,
                letterSpacing: 2),
            const SizedBox(height: 4),
            // Section title
            _text('New Arrivals', AppFonts.headline, 24,
                isDark ? Colors.white : AppColors.neutral,
                bold: true),
            const SizedBox(height: 16),
            // Products grid (2 columns)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.6,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: newArrivals.length,
              itemBuilder: (context, index) => buildProductCard(
                newArrivals[index],
                isDark: isDark,
                context: context,
              ),
            ),
          ],
        ),
      );

  // Build product card widget
  Widget buildProductCard(
    ProductModel product, {
    bool isHorizontal = false,
    required bool isDark,
    required BuildContext context,
  }) {
    return GestureDetector(
      // Navigate to product details on tap
      onTap: () => AppRoutes.goToProductDetails(context, product),
      child: Container(
        width: isHorizontal ? 160 : null,
        margin: isHorizontal ? const EdgeInsets.only(right: 16) : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image with badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    height: isHorizontal ? 140 : 160,
                    width: double.infinity,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.06)
                        : AppColors.secondary,
                    child: _buildProductImage(product.imageUrl, isDark),
                  ),
                ),
                // Show badge if exists
                if (product.badge != null)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.tertiary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: _text(
                        product.badge!,
                        AppFonts.label,
                        8,
                        AppColors.white,
                        bold: true,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            // Product name
            _text(product.name, AppFonts.headline, 14,
                isDark ? Colors.white : AppColors.neutral,
                bold: true),
            const SizedBox(height: 2),
            // Product subtitle
            _text(product.subtitle, AppFonts.body, 12, AppColors.textSecondary),
            const SizedBox(height: 4),
            // Product price
            _text('\$${product.price.toStringAsFixed(2)}', AppFonts.label, 14,
                AppColors.primary,
                bold: true),
          ],
        ),
      ),
    );
  }

  // Build product image with error handling
  Widget _buildProductImage(String imageUrl, bool isDark) {
    // Network image
    if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        // Show placeholder on error
        errorBuilder: (_, __, ___) => _buildErrorPlaceholder(isDark),
        // Show loader while loading
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : AppColors.secondary,
            child: const Center(child: CircularProgressIndicator()),
          );
        },
      );
    } else {
      // Asset image
      return Image.asset(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (_, __, ___) => _buildErrorPlaceholder(isDark),
      );
    }
  }

  // Build error placeholder when image fails
  Widget _buildErrorPlaceholder(bool isDark) => Container(
        color: isDark
            ? Colors.white.withValues(alpha: 0.06)
            : AppColors.secondary,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image_outlined,
                size: 40,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.3)
                    : AppColors.textSecondary.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 8),
              _text('No Image', AppFonts.label, 10,
                  isDark
                      ? Colors.white.withValues(alpha: 0.5)
                      : AppColors.textSecondary.withValues(alpha: 0.7)),
            ],
          ),
        ),
      );

  // ─── PRIVATE HELPERS ───

  // View collection link widget
  Widget _viewCollectionLink() => GestureDetector(
        onTap: () {},
        child: Row(
          children: [
            _text('View collection', AppFonts.body, 12, AppColors.primary),
            Icon(Icons.arrow_forward_ios, size: 12, color: AppColors.primary),
          ],
        ),
      );

  // Quick text widget
  Widget _text(
    String text,
    String font,
    double size,
    Color color, {
    bool bold = false,
    double letterSpacing = 0,
  }) =>
      Text(
        text,
        style: _textStyle(font, size, color, bold: bold, letterSpacing: letterSpacing),
      );

  // Text style helper
  TextStyle _textStyle(
    String font,
    double size,
    Color color, {
    bool bold = false,
    double letterSpacing = 0,
  }) =>
      TextStyle(
        fontFamily: font,
        fontSize: size,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        color: color,
        letterSpacing: letterSpacing,
      );

  // Dispose email controller
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}