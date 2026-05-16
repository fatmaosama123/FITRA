// lib/widgets/product_card.dart

import 'package:flutter/material.dart';
import '../core/constants/colors.dart';
import '../core/constants/fonts.dart';
import '../models/product_model.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final bool isDark;

  const ProductCard({super.key, required this.product, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/product-details', arguments: product);
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : AppColors.secondary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.05),
            width: 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.05)
                          : AppColors.secondary,
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.3)
                            : AppColors.textSecondary,
                      ),
                    );
                  },
                ),
              ),
            ),

            // Product Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category tag
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.1)
                          : Colors.black.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      product.category.toUpperCase(),
                      style: TextStyle(
                        fontFamily: AppFonts.label,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.7)
                            : AppColors.neutral,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Product Name
                  Text(
                    product.name,
                    style: TextStyle(
                      fontFamily: AppFonts.headline,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : AppColors.neutral,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),

                  // Subtitle
                  Text(
                    product.subtitle,
                    style: TextStyle(
                      fontFamily: AppFonts.body,
                      fontSize: 12,
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.5)
                          : AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Price
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontFamily: AppFonts.label,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.8)
                          : AppColors.neutral,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
