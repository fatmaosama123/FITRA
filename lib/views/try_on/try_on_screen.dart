// lib/views/try_on/try_on_screen.dart

import 'package:flutter/material.dart';
import '../../controllers/try_on_controller.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/fonts.dart';
import '../../models/try_on_model.dart';

class TryOnScreen extends StatefulWidget {
  const TryOnScreen({super.key});

  @override
  State<TryOnScreen> createState() => _TryOnScreenState();
}

class _TryOnScreenState extends State<TryOnScreen> {
  final controller = TryOnController();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: bgColor,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24),

                // Title
                Text(
                  'Virtual Try-On',
                  style: TextStyle(
                    fontFamily: AppFonts.headline,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.white : AppColors.neutral,
                  ),
                ),

                const SizedBox(height: 12),

                // Description
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'Experience our curated collection on your own silhouette. Upload a clear full-body photo for the best results.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppFonts.body,
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Upload Card
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.06)
                        : Colors.black.withValues(alpha: 0.03),
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
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.08)
                              : Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.camera_alt_outlined,
                          color: AppColors.primary,
                          size: 28,
                        ),
                      ),

                      const SizedBox(height: 16),

                      Text(
                        'Upload Your Photo',
                        style: TextStyle(
                          fontFamily: AppFonts.headline,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.white : AppColors.neutral,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'Drag and drop or tap to use your camera for an instant fitting.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: AppFonts.body,
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 20),

                      GestureDetector(
                        onTap: controller.uploadPhoto,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.08)
                                : AppColors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.1)
                                  : AppColors.textSecondary.withValues(
                                      alpha: 0.2,
                                    ),
                            ),
                          ),
                          child: Text(
                            'Choose File',
                            style: TextStyle(
                              fontFamily: AppFonts.label,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? Colors.white70
                                  : AppColors.neutral,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Pro Tips
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PRO TIPS',
                        style: TextStyle(
                          fontFamily: AppFonts.label,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                          letterSpacing: 1.5,
                        ),
                      ),

                      const SizedBox(height: 12),

                      _buildProTip('Stand against a plain wall', isDark),
                      _buildProTip('Ensure even, natural lighting', isDark),
                      _buildProTip('Wear form-fitting base layers', isDark),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Live Preview Card
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  height: 280,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.tertiary.withValues(alpha: 0.3)
                        : const Color(0xFFF5D0A9),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Stack(
                    children: [
                      // Live Preview Label
                      Positioned(
                        top: 16,
                        left: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.black.withValues(alpha: 0.6)
                                : AppColors.white.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            'LIVE PREVIEW',
                            style: TextStyle(
                              fontFamily: AppFonts.label,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : AppColors.neutral,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),

                      // Silhouette Image
                      Center(
                        child: Image.network(
                          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300&h=500&fit=crop',
                          height: 200,
                          fit: BoxFit.contain,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              width: 120,
                              height: 200,
                              color: isDark ? Colors.black54 : Colors.black26,
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 120,
                              height: 200,
                              color: isDark ? Colors.black54 : Colors.black26,
                              child: const Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                            );
                          },
                        ),
                      ),

                      // Selected Item Card
                      Positioned(
                        bottom: 16,
                        left: 16,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.black.withValues(alpha: 0.7)
                                : AppColors.white.withValues(alpha: 0.95),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'SELECTED ITEM',
                                      style: TextStyle(
                                        fontFamily: AppFonts.label,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primary,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Linear Wool Coat',
                                      style: TextStyle(
                                        fontFamily: AppFonts.headline,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: isDark
                                            ? Colors.white
                                            : AppColors.neutral,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '\$340.00',
                                      style: TextStyle(
                                        fontFamily: AppFonts.label,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: isDark
                                            ? Colors.white
                                            : AppColors.neutral,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Row(
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: const BoxDecoration(
                                      color: Colors.black,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? Colors.grey[600]
                                          : Colors.grey[300],
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Try It On Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GestureDetector(
                    onTap: controller.tryItOn,
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.tertiary.withValues(alpha: 0.8),
                            AppColors.tertiary,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.tertiary.withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.face_retouching_natural,
                            color: Colors.white,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Try It On',
                            style: TextStyle(
                              fontFamily: AppFonts.label,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // More Options Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'MORE OPTIONS',
                        style: TextStyle(
                          fontFamily: AppFonts.label,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                          letterSpacing: 1.5,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Ready to pair?',
                            style: TextStyle(
                              fontFamily: AppFonts.headline,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : AppColors.neutral,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              'View Wardrobe',
                              style: TextStyle(
                                fontFamily: AppFonts.body,
                                fontSize: 14,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Recommended Products Grid
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.65,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                    itemCount: controller.recommendedProducts.length,
                    itemBuilder: (context, index) {
                      return _buildProductCard(
                        controller.recommendedProducts[index],
                        isDark,
                      );
                    },
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

  Widget _buildProTip(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 6, right: 10),
            decoration: BoxDecoration(
              color: AppColors.textSecondary,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: AppFonts.body,
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(TryOnProduct product, bool isDark) {
    return GestureDetector(
      onTap: () => controller.selectProduct(product),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.06)
                    : AppColors.secondary,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary.withValues(alpha: 0.5),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Icon(
                        Icons.image_not_supported,
                        color: AppColors.textSecondary.withValues(alpha: 0.5),
                        size: 40,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            product.name,
            style: TextStyle(
              fontFamily: AppFonts.headline,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : AppColors.neutral,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '\$${product.price.toStringAsFixed(2)}',
            style: TextStyle(
              fontFamily: AppFonts.label,
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
