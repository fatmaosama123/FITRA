// lib/views/cart/cart_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/cart_controller.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/fonts.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _promoCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer<CartController>(
      builder: (context, ctrl, _) => Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: ctrl.items.isEmpty
            // Empty state from controller
            ? ctrl.buildEmptyState(isDark)
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    // Header
                    _buildHeader(ctrl.itemCount, isDark),
                    const SizedBox(height: 24),
                    // Cart items from controller
                    ...ctrl.items.map((item) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: ctrl.buildCartItem(item, isDark, context),
                        )),
                    const SizedBox(height: 24),
                    // Promo code from controller
                    ctrl.buildPromoCode(isDark, _promoCtrl),
                    const SizedBox(height: 24),
                    // Summary from controller
                    ctrl.buildSummary(isDark),
                    const SizedBox(height: 24),
                    // Checkout button from controller
                    ctrl.buildCheckoutButton(context),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
      ),
    );
  }

  // Only header stays in view (simple text)
  Widget _buildHeader(int count, bool isDark) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
            '$count items curated for you',
            style: TextStyle(
              fontFamily: AppFonts.body,
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      );
}