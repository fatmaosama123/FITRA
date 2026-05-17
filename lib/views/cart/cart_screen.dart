// lib/views/cart/cart_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/cart_controller.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/fonts.dart';
import '../../routes/app_routes.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final promoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;

    return Consumer<CartController>(
      builder: (context, controller, child) {
        return Scaffold(
          backgroundColor: bgColor,
          body: controller.items.isEmpty
              ? _buildEmptyState(isDark)
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),

                      Text(
                        'Your Cart',
                        style: TextStyle(
                          fontFamily: AppFonts.headline,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.white : AppColors.neutral,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        '${controller.itemCount} items curated for you',
                        style: TextStyle(
                          fontFamily: AppFonts.body,
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),

                      const SizedBox(height: 24),

                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.items.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          return _buildCartItem(
                            controller,
                            controller.items[index],
                            isDark,
                          );
                        },
                      ),

                      const SizedBox(height: 24),

                      _buildPromoCode(controller, isDark),

                      const SizedBox(height: 24),

                      _buildSummary(controller, isDark),

                      const SizedBox(height: 24),

                      _buildCheckoutButton(controller),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 80,
            color: AppColors.textSecondary.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'Your cart is empty',
            style: TextStyle(
              fontFamily: AppFonts.headline,
              fontSize: 20,
              color: isDark ? AppColors.white : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start curating your wardrobe',
            style: TextStyle(
              fontFamily: AppFonts.body,
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(CartController controller, item, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.06)
            : Colors.black.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.black.withValues(alpha: 0.05),
          width: 0.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              item.imageUrl,
              width: 100,
              height: 120,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 100,
                  height: 120,
                  color: AppColors.secondary,
                  child: Icon(
                    Icons.image_not_supported,
                    color: AppColors.textSecondary.withValues(alpha: 0.5),
                  ),
                );
              },
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        style: TextStyle(
                          fontFamily: AppFonts.headline,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.white : AppColors.neutral,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => controller.removeItem(item.id),
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.08)
                              : Colors.black.withValues(alpha: 0.05),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                Text(
                  'Size: ${item.size}',
                  style: TextStyle(
                    fontFamily: AppFonts.body,
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),

                Text(
                  'Color: ${item.color}',
                  style: TextStyle(
                    fontFamily: AppFonts.body,
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                          IconButton(
                            icon: Icon(
                              Icons.remove,
                              size: 18,
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                            onPressed: () =>
                                controller.updateQuantity(item.id, -1),
                          ),
                          Text(
                            '${item.quantity}',
                            style: TextStyle(
                              fontFamily: AppFonts.label,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppColors.white
                                  : AppColors.neutral,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.add,
                              size: 18,
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                            onPressed: () =>
                                controller.updateQuantity(item.id, 1),
                          ),
                        ],
                      ),
                    ),

                    Flexible(
                      child: Text(
                        '\$${item.totalPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontFamily: AppFonts.headline,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoCode(CartController controller, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.06)
            : AppColors.secondary.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: promoController,
              decoration: InputDecoration(
                hintText: 'Enter promo code',
                hintStyle: TextStyle(
                  fontFamily: AppFonts.body,
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              controller.applyPromo(promoController.text);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.neutral,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                'Apply',
                style: TextStyle(
                  fontFamily: AppFonts.label,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary(CartController controller, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.06)
            : Colors.black.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.black.withValues(alpha: 0.05),
          width: 0.5,
        ),
      ),
      child: Column(
        children: [
          _buildSummaryRow(
            'Subtotal',
            '\$${controller.subtotal.toStringAsFixed(2)}',
            isDark,
          ),
          const SizedBox(height: 8),
          _buildSummaryRow(
            'Shipping',
            controller.shipping == 0
                ? 'Free'
                : '\$${controller.shipping.toStringAsFixed(2)}',
            isDark,
          ),
          const SizedBox(height: 8),
          _buildSummaryRow(
            'Estimated Tax',
            '\$${controller.tax.toStringAsFixed(2)}',
            isDark,
          ),
          if (controller.discount > 0) ...[
            const SizedBox(height: 8),
            _buildSummaryRow(
              'Discount',
              '-\$${controller.discount.toStringAsFixed(2)}',
              isDark,
              isDiscount: true,
            ),
          ],
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(),
          ),
          _buildSummaryRow(
            'Total',
            '\$${controller.total.toStringAsFixed(2)}',
            isDark,
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value,
    bool isDark, {
    bool isTotal = false,
    bool isDiscount = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: isTotal ? AppFonts.headline : AppFonts.body,
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isDark ? AppColors.white : AppColors.neutral,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: isTotal ? AppFonts.headline : AppFonts.body,
            fontSize: isTotal ? 24 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isDiscount
                ? AppColors.primary
                : (isTotal
                      ? (isDark ? AppColors.white : AppColors.neutral)
                      : AppColors.textSecondary),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckoutButton(CartController controller) {
    return GestureDetector(
      onTap: () {
        if (controller.items.isNotEmpty) {
          AppRoutes.goToCheckout(context);
        }
      },
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withValues(alpha: 0.8),
              AppColors.primary,
            ],
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Center(
          child: Text(
            'Proceed to Checkout',
            style: TextStyle(
              fontFamily: AppFonts.label,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
