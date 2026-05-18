// lib/controllers/product_details_controller.dart

import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../models/cart_item.dart';
import '../core/constants/colors.dart';
import '../core/constants/fonts.dart';

// Manages product details state and all UI builders
class ProductDetailsController extends ChangeNotifier {

  // ─── Product Data ───

  // Current product being viewed
  ProductModel? product;

  // Selected options
  int selectedColorIndex = 0;
  int selectedSizeIndex = 1;
  int quantity = 1;

  // Expandable sections state
  bool isMaterialExpanded = false;
  bool isShippingExpanded = false;

  // ─── Options ───

  // Available colors
  final List<Map<String, dynamic>> colors = [
    {'name': 'Forest Green', 'color': const Color(0xFF2D5016)},
    {'name': 'Midnight Black', 'color': Colors.black},
    {'name': 'Natural Beige', 'color': const Color(0xFFF5F5DC)},
  ];

  // Available sizes
  final List<String> sizes = ['XS', 'S', 'M', 'L', 'XL'];

  // ─── Getters ───

  String get selectedSize => sizes[selectedSizeIndex];
  String get selectedColorName => colors[selectedColorIndex]['name'];

  // ─── Init ───

  void init(ProductModel? p) {
    product = p;
    notifyListeners();
  }

  // ─── Selection Methods ───

  void selectColor(int index) {
    selectedColorIndex = index;
    notifyListeners();
  }

  void selectSize(int index) {
    selectedSizeIndex = index;
    notifyListeners();
  }

  void toggleMaterial() {
    isMaterialExpanded = !isMaterialExpanded;
    notifyListeners();
  }

  void toggleShipping() {
    isShippingExpanded = !isShippingExpanded;
    notifyListeners();
  }

  void incrementQuantity() {
    quantity++;
    notifyListeners();
  }

  void decrementQuantity() {
    if (quantity > 1) {
      quantity--;
      notifyListeners();
    }
  }

  // ─── Cart ───

  // Build cart item from current selections
  CartItem? buildCartItem() {
    if (product == null) return null;
    return CartItem(
      id: product!.id,
      name: product!.name,
      imageUrl: product!.imageUrl,
      price: product!.price,
      size: selectedSize,
      color: selectedColorName,
      quantity: quantity,
    );
  }

  // ─── UI BUILDERS ───

  // Build product image with hero animation
  Widget buildProductImage(bool isDark) {
    if (product == null) return const SizedBox.shrink();

    return Hero(
      tag: 'product_${product!.id}',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: AspectRatio(
          aspectRatio: 1,
          child: Image.network(
            product!.imageUrl,
            fit: BoxFit.cover,
            // Error placeholder
            errorBuilder: (_, __, ___) => Container(
              color: Colors.grey[300],
              child: const Icon(Icons.image_not_supported, size: 50),
            ),
          ),
        ),
      ),
    );
  }

  // Build product name text
  Widget buildProductName(bool isDark) => _text(
        product?.name ?? '',
        AppFonts.headline,
        26,
        isDark ? Colors.white : AppColors.neutral,
        bold: true,
      );

  // Build product price text
  Widget buildProductPrice() => _text(
        '\$${product?.price.toStringAsFixed(2) ?? '0.00'}',
        AppFonts.label,
        22,
        AppColors.primary,
        bold: true,
      );

  // Build color selection section
  Widget buildColorSection(bool isDark) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Select Color', isDark),
          const SizedBox(height: 12),
          Row(
            children: List.generate(
              colors.length,
              (index) => Padding(
                padding: const EdgeInsets.only(right: 12),
                child: buildColorCircle(index),
              ),
            ),
          ),
        ],
      );

  // Build color circle button
  Widget buildColorCircle(int index) {
    final colorData = colors[index];
    final isSelected = selectedColorIndex == index;

    return GestureDetector(
      onTap: () => selectColor(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: isSelected ? 44 : 36,
        height: isSelected ? 44 : 36,
        decoration: BoxDecoration(
          color: colorData['color'],
          shape: BoxShape.circle,
          // Selected border
          border: isSelected
              ? Border.all(color: AppColors.primary, width: 3)
              : Border.all(color: Colors.transparent, width: 2),
          // Selected shadow
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        // Check icon when selected
        child: isSelected
            ? const Icon(Icons.check, color: Colors.white, size: 18)
            : null,
      ),
    );
  }

  // Build size selection section
  Widget buildSizeSection(bool isDark) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Select Size', isDark),
          const SizedBox(height: 12),
          Row(
            children: List.generate(
              sizes.length,
              (index) => Padding(
                padding: const EdgeInsets.only(right: 12),
                child: buildSizeButton(index),
              ),
            ),
          ),
        ],
      );

  // Build size button
  Widget buildSizeButton(int index) {
    final size = sizes[index];
    final isSelected = selectedSizeIndex == index;

    return GestureDetector(
      onTap: () => selectSize(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 48,
        height: 44,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(22),
          border: isSelected
              ? null
              : Border.all(
                  color: AppColors.textSecondary.withValues(alpha: 0.3),
                ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Center(
          child: _text(size, AppFonts.label, 14,
              isSelected ? Colors.white : AppColors.neutral,
              bold: true),
        ),
      ),
    );
  }

  // Build expandable info card
  Widget buildExpandableCard({
    required IconData icon,
    required String title,
    required List<String> content,
    required bool isExpanded,
    required VoidCallback onToggle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Card header with toggle
          GestureDetector(
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Icon(icon, color: AppColors.primary, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _text(title, AppFonts.headline, 16, AppColors.neutral,
                        bold: true),
                  ),
                  // Animated arrow
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Expandable content
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: content.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _text(item, AppFonts.body, 13, AppColors.textSecondary),
                  );
                }).toList(),
              ),
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }

  // Build quantity selector
  Widget buildQuantitySelector(bool isDark) => Row(
        children: [
          _sectionTitle('Quantity', isDark),
          const Spacer(),
          Container(
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Decrease
                IconButton(
                  icon: Icon(
                    Icons.remove,
                    size: 18,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                  onPressed: decrementQuantity,
                ),
                // Quantity text
                _text('$quantity', AppFonts.label, 14,
                    isDark ? AppColors.white : AppColors.neutral,
                    bold: true),
                // Increase
                IconButton(
                  icon: Icon(
                    Icons.add,
                    size: 18,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                  onPressed: incrementQuantity,
                ),
              ],
            ),
          ),
        ],
      );

  // Build add to cart button
  Widget buildAddToCartButton(VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary.withValues(alpha: 0.8),
                AppColors.primary,
                AppColors.primary.withValues(alpha: 0.9),
              ],
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.2),
                blurRadius: 40,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shopping_bag_outlined,
                  color: Colors.white, size: 20),
              const SizedBox(width: 10),
              _text('ADD TO CART', AppFonts.label, 16, Colors.white,
                  bold: true),
            ],
          ),
        ),
      );

  // Build success snackbar
  Widget buildSuccessSnackBar() => SnackBar(
        content: Row(
          children: [
            // Success icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 12),
            // Success message
            Expanded(
              child: _text(
                'Added to cart successfully!',
                AppFonts.label,
                14,
                AppColors.neutral,
                bold: true,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: Colors.black.withValues(alpha: 0.05),
            width: 1,
          ),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
        elevation: 8,
      );

  // ─── PRIVATE HELPERS ───

  // Section title text
  Widget _sectionTitle(String text, bool isDark) => _text(
        text,
        AppFonts.headline,
        16,
        isDark ? Colors.white : AppColors.neutral,
        bold: true,
      );

  // Quick text widget
  Widget _text(
    String text,
    String font,
    double size,
    Color color, {
    bool bold = false,
  }) =>
      Text(
        text,
        style: _textStyle(font, size, color, bold: bold),
      );

  // Text style helper
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
      );
}