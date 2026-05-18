// lib/controllers/try_on_controller.dart

import 'package:flutter/material.dart';
import '../models/try_on_model.dart';
import '../core/constants/colors.dart';
import '../core/constants/fonts.dart';

// Manages virtual try-on feature state and UI builders
class TryOnController extends ChangeNotifier {

  // ─── State ───

  // Uploaded user photo path
  String? uploadedImagePath;
  // Photo upload loading state
  bool isUploading = false;
  // Currently selected product for try-on
  TryOnProduct? selectedProduct;

  // ─── Data ───

  // Recommended products list
  final List<TryOnProduct> recommendedProducts = TryOnProduct.getRecommended();

  // ─── Methods ───

  // Simulate photo upload with delay
  void uploadPhoto() {
    isUploading = true;
    notifyListeners();

    Future.delayed(const Duration(seconds: 1), () {
      uploadedImagePath =
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=600&fit=crop';
      isUploading = false;
      notifyListeners();
    });
  }

  // Select product for try-on
  void selectProduct(TryOnProduct product) {
    selectedProduct = product;
    notifyListeners();
  }

  // Trigger AI try-on (not implemented yet)
  void tryItOn() {
    // TODO: Implement AI try-on logic
  }

  // ─── UI BUILDERS ───

  // Build page title
  Widget buildTitle(bool isDark) => _text(
        'Virtual Try-On',
        AppFonts.headline,
        32,
        isDark ? AppColors.white : AppColors.neutral,
        bold: true,
      );

  // Build description text
  Widget buildDescription() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: _text(
          'Experience our curated collection on your own silhouette. Upload a clear full-body photo for the best results.',
          AppFonts.body,
          14,
          AppColors.textSecondary,
          textAlign: TextAlign.center,
        ),
      );

  // Build upload photo card
  Widget buildUploadCard(bool isDark) => Container(
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
            // Camera icon
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
            // Upload title
            _text(
              'Upload Your Photo',
              AppFonts.headline,
              18,
              isDark ? AppColors.white : AppColors.neutral,
              bold: true,
            ),
            const SizedBox(height: 8),
            // Upload description
            _text(
              'Drag and drop or tap to use your camera for an instant fitting.',
              AppFonts.body,
              13,
              AppColors.textSecondary,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // Choose file button
            _chooseFileButton(isDark),
          ],
        ),
      );

  // Build choose file button
  Widget _chooseFileButton(bool isDark) => GestureDetector(
        onTap: uploadPhoto,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : AppColors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : AppColors.textSecondary.withValues(alpha: 0.2),
            ),
          ),
          child: _text(
            'Choose File',
            AppFonts.label,
            14,
            isDark ? Colors.white70 : AppColors.neutral,
            bold: true,
          ),
        ),
      );

  // Build pro tips section
  Widget buildProTips(bool isDark) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _text(
              'PRO TIPS',
              AppFonts.label,
              10,
              AppColors.textSecondary,
              bold: true,
              letterSpacing: 1.5,
            ),
            const SizedBox(height: 12),
            _buildProTip('Stand against a plain wall', isDark),
            _buildProTip('Ensure even, natural lighting', isDark),
            _buildProTip('Wear form-fitting base layers', isDark),
          ],
        ),
      );

  // Build single pro tip
  Widget _buildProTip(String text, bool isDark) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bullet point
            Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.only(top: 6, right: 10),
              decoration: BoxDecoration(
                color: AppColors.textSecondary,
                shape: BoxShape.circle,
              ),
            ),
            // Tip text
            Expanded(
              child: _text(text, AppFonts.body, 13, AppColors.textSecondary),
            ),
          ],
        ),
      );

  // Build live preview card
  Widget buildLivePreview(bool isDark) => Container(
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
            // Live preview label
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.6)
                      : AppColors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: _text(
                  'LIVE PREVIEW',
                  AppFonts.label,
                  10,
                  isDark ? Colors.white : AppColors.neutral,
                  bold: true,
                  letterSpacing: 1,
                ),
              ),
            ),
            // Silhouette image
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
                errorBuilder: (_, __, ___) => Container(
                  width: 120,
                  height: 200,
                  color: isDark ? Colors.black54 : Colors.black26,
                  child: const Icon(Icons.person, color: Colors.white),
                ),
              ),
            ),
            // Selected item card
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: _selectedItemCard(isDark),
            ),
          ],
        ),
      );

  // Build selected item card in preview
  Widget _selectedItemCard(bool isDark) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.black.withValues(alpha: 0.7)
              : AppColors.white.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            // Product info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _text(
                    'SELECTED ITEM',
                    AppFonts.label,
                    9,
                    AppColors.primary,
                    bold: true,
                    letterSpacing: 1,
                  ),
                  const SizedBox(height: 4),
                  _text(
                    'Linear Wool Coat',
                    AppFonts.headline,
                    16,
                    isDark ? Colors.white : AppColors.neutral,
                    bold: true,
                  ),
                  const SizedBox(height: 2),
                  _text(
                    '\$340.00',
                    AppFonts.label,
                    14,
                    isDark ? Colors.white : AppColors.neutral,
                    bold: true,
                  ),
                ],
              ),
            ),
            // Color options
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
                    color: isDark ? Colors.grey[600] : Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  // Build try it on button
  Widget buildTryItOnButton(bool isDark) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: GestureDetector(
          onTap: tryItOn,
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
                _text('Try It On', AppFonts.label, 16, Colors.white, bold: true),
              ],
            ),
          ),
        ),
      );

  // Build more options header
  Widget buildMoreOptionsHeader(bool isDark) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _text(
              'MORE OPTIONS',
              AppFonts.label,
              10,
              AppColors.textSecondary,
              bold: true,
              letterSpacing: 1.5,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _text(
                  'Ready to pair?',
                  AppFonts.headline,
                  24,
                  isDark ? Colors.white : AppColors.neutral,
                  bold: true,
                ),
                GestureDetector(
                  onTap: () {},
                  child: _text(
                    'View Wardrobe',
                    AppFonts.body,
                    14,
                    AppColors.primary,
                    bold: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  // Build recommended products grid
  Widget buildRecommendedGrid(bool isDark) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.65,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: recommendedProducts.length,
          itemBuilder: (context, index) => _buildProductCard(
            recommendedProducts[index],
            isDark,
          ),
        ),
      );

  // Build single product card
  Widget _buildProductCard(TryOnProduct product, bool isDark) => GestureDetector(
        onTap: () => selectProduct(product),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
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
                    errorBuilder: (_, __, ___) => Center(
                      child: Icon(
                        Icons.image_not_supported,
                        color: AppColors.textSecondary.withValues(alpha: 0.5),
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Product name
            _text(
              product.name,
              AppFonts.headline,
              14,
              isDark ? Colors.white : AppColors.neutral,
              bold: true,
            ),
            const SizedBox(height: 2),
            // Product price
            _text(
              '\$${product.price.toStringAsFixed(2)}',
              AppFonts.label,
              13,
              AppColors.textSecondary,
            ),
          ],
        ),
      );

  // ─── PRIVATE HELPERS ───

  // Quick text widget
  Widget _text(
    String text,
    String font,
    double size,
    Color color, {
    bool bold = false,
    TextAlign? textAlign,
    double letterSpacing = 0,
  }) =>
      Text(
        text,
        textAlign: textAlign,
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
}