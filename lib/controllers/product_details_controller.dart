// lib/controllers/product_details_controller.dart

import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../core/constants/colors.dart';
import '../core/constants/fonts.dart';
import '../routes/app_routes.dart';

class ProductDetailsController extends ChangeNotifier {
  ProductModel? product;

  int selectedColorIndex = 0;
  int selectedSizeIndex = 1;

  bool isMaterialExpanded = false;
  bool isShippingExpanded = false;

  int quantity = 1;

  final List<Map<String, dynamic>> colors = [
    {'name': 'Forest Green', 'color': const Color(0xFF2D5016)},
    {'name': 'Midnight Black', 'color': Colors.black},
    {'name': 'Natural Beige', 'color': const Color(0xFFF5F5DC)},
  ];

  final List<String> sizes = ['XS', 'S', 'M', 'L', 'XL'];

  void init(ProductModel? p) {
    product = p;
    notifyListeners();
  }

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

  String get selectedSize => sizes[selectedSizeIndex];
  String get selectedColorName => colors[selectedColorIndex]['name'];

  Map<String, dynamic> getCartData() {
    return {
      'product': product,
      'size': selectedSize,
      'color': selectedColorName,
      'quantity': quantity,
    };
  }

  void goBack(BuildContext context) {
    AppRoutes.goBack(context);
  }

  Widget buildColorCircle(int index, BuildContext context) {
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
          border: isSelected
              ? Border.all(color: AppColors.primary, width: 3)
              : Border.all(color: Colors.transparent, width: 2),
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
        child: isSelected
            ? const Icon(Icons.check, color: Colors.white, size: 18)
            : null,
      ),
    );
  }

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
          child: Text(
            size,
            style: TextStyle(
              fontFamily: AppFonts.label,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : AppColors.neutral,
            ),
          ),
        ),
      ),
    );
  }

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
          GestureDetector(
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Icon(icon, color: AppColors.primary, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontFamily: AppFonts.headline,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.neutral,
                      ),
                    ),
                  ),
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
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: content.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      item,
                      style: TextStyle(
                        fontFamily: AppFonts.body,
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
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
}
