// lib/views/checkout/checkout_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/checkout_controller.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/fonts.dart';
import '../../widgets/custom_app_bar.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final controller = CheckoutController();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cartController = context.watch<CartController>();

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) => Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: CustomAppBar(
          title: 'Checkout',
          showMenu: false,
          showNotification: false,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: isDark ? AppColors.white : AppColors.neutral,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: controller.isProcessing
            ? controller.buildProcessingState()
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    _buildTitle(isDark),
                    const SizedBox(height: 24),
                    // Shipping Address
                    controller.buildSectionTitle('Shipping Address', isDark),
                    const SizedBox(height: 12),
                    controller.buildAddressCard(isDark),
                    const SizedBox(height: 24),
                    // Payment Method
                    controller.buildSectionTitle('Payment Method', isDark),
                    const SizedBox(height: 12),
                    controller.buildPaymentMethods(isDark),
                    const SizedBox(height: 24),
                    // Order Summary
                    controller.buildSectionTitle('Order Summary', isDark),
                    const SizedBox(height: 12),
                    controller.buildOrderSummary(
                      cartController,
                      isDark,
                      () => Navigator.pop(context),
                    ),
                    const SizedBox(height: 24),
                    // Place Order Button
                    controller.buildPlaceOrderButton(
                      cartController,
                      isDark,
                      () => _handlePlaceOrder(cartController, isDark),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
      ),
    );
  }

  // Title section
  Widget _buildTitle(bool isDark) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Checkout',
            style: TextStyle(
              fontFamily: AppFonts.headline,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.white : AppColors.neutral,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Complete your purchase',
            style: TextStyle(
              fontFamily: AppFonts.body,
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      );

  // Handle place order with success dialog
  Future<void> _handlePlaceOrder(CartController cart, bool isDark) async {
    await controller.placeOrder();

    if (!mounted) return;

    final orderNumber =
        DateTime.now().millisecondsSinceEpoch.toString().substring(5);

    showDialog(
      context: context,
      builder: (_) => controller.buildSuccessDialog(
        isDark,
        orderNumber,
        () {
          cart.clearCart();
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/main',
            (route) => false,
          );
        },
      ),
    );
  }
}