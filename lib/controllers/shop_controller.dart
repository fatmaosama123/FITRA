// lib/controllers/shop_controller.dart

import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import '../core/constants/colors.dart';
import '../core/constants/fonts.dart';
import '../routes/app_routes.dart';

class ShopController extends ChangeNotifier {
  List<CategoryModel> get categories => CategoryModel.allCategories;
  List<Map<String, String>> get seasonalEdits => CategoryModel.seasonalEdits;

  void openCategory(BuildContext context, CategoryModel category) {
    AppRoutes.goToCategoryDetails(context, category.name);
  }

  void openCollectionDetails(BuildContext context, String title) {
    AppRoutes.goToCollectionDetails(context, title);
  }

  // ========== كارد الكاتيجوري ==========

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
              Image.network(
                category.imageUrl,
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
              ),
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
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (category.title.isNotEmpty)
                      Text(
                        category.title,
                        style: TextStyle(
                          fontFamily: AppFonts.label,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.7)
                              : category.textColor.withValues(alpha: 0.7),
                          letterSpacing: 1.5,
                        ),
                      ),
                    if (category.title.isNotEmpty) const SizedBox(height: 4),
                    Text(
                      category.subtitle,
                      style: TextStyle(
                        fontFamily: AppFonts.headline,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : category.textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      category.description,
                      style: TextStyle(
                        fontFamily: AppFonts.body,
                        fontSize: 12,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.8)
                            : category.textColor.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: 12),
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ========== كارد Seasonal Edit ==========

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
              style: TextStyle(
                fontFamily: AppFonts.headline,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.15)
                    : AppColors.secondaryDark,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                edit['title']!,
                style: TextStyle(
                  fontFamily: AppFonts.headline,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.5)
                      : AppColors.neutral,
                ),
              ),
            ),
            Icon(Icons.arrow_forward, color: AppColors.primary, size: 20),
          ],
        ),
      ),
    );
  }
}
