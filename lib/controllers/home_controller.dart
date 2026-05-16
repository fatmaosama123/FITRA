// lib/controllers/home_controller.dart

import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../core/constants/colors.dart';
import '../core/constants/fonts.dart';
import '../routes/route_names.dart';
import '../routes/app_routes.dart';

class HomeController extends ChangeNotifier {
  // Categories
  final List<String> categories = [
    'All Essentials',
    'Loungewear',
    'Denim',
    'Accessories',
    'Shoes',
  ];

  int selectedCategoryIndex = 0;

  // Products
  List<ProductModel> get newArrivals => ProductModel.newArrivals;
  List<ProductModel> get trendingProducts => ProductModel.trending;

  // Search
  String searchQuery = '';

  // Email subscription
  final emailController = TextEditingController();

  void selectCategory(int index, BuildContext context) {
    selectedCategoryIndex = index;
    notifyListeners();

    // فتح صفحة الكاتيجوري
    AppRoutes.goToCategoryDetails(context, categories[index]);
  }

  void updateSearch(String query) {
    searchQuery = query;
    notifyListeners();
  }

  void subscribeEmail() {
    debugPrint('Subscribing email: ${emailController.text}');
    emailController.clear();
    notifyListeners();
  }

  // Product Card Widget (from Controller)
  Widget buildProductCard(
    ProductModel product, {
    bool isHorizontal = false,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: () => AppRoutes.goToProductDetails,
      child: Container(
        width: isHorizontal ? 160 : null,
        margin: isHorizontal ? const EdgeInsets.only(right: 16) : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                      child: Text(
                        product.badge!,
                        style: TextStyle(
                          fontFamily: AppFonts.label,
                          fontSize: 8,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              product.name,
              style: TextStyle(
                fontFamily: AppFonts.headline,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : AppColors.neutral,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              product.subtitle,
              style: TextStyle(
                fontFamily: AppFonts.body,
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: TextStyle(
                fontFamily: AppFonts.label,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // دالة منفصلة للصورة مع error handling
  Widget _buildProductImage(String imageUrl, bool isDark) {
    return Image.asset(
      imageUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (context, error, stackTrace) {
        return Container(
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
                Text(
                  'No Image',
                  style: TextStyle(
                    fontFamily: AppFonts.label,
                    fontSize: 10,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.5)
                        : AppColors.textSecondary.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
