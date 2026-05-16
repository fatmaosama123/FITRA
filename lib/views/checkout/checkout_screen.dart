// lib/views/checkout/checkout_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/checkout_controller.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/fonts.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/bottom_nav_bar.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final controller = CheckoutController();
  int _currentNavIndex = 3; // CART tab selected

  void _onNavTap(int index) {
    setState(() {
      _currentNavIndex = index;
    });

    switch (index) {
      case 0: // HOME
        Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
        break;
      case 1: // SHOP
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/category-details',
          (route) => false,
        );
        break;
      case 2: // TRY-ON
        Navigator.pushNamed(context, '/try-on');
        break;
      case 3: // CART
        Navigator.pushNamed(context, '/cart');
        break;
      case 4: // PROFILE
        Navigator.pushNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final cartController = context.watch<CartController>();

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: bgColor,

          appBar: CustomAppBar(
            title: 'Checkout',
            showMenu: false,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: isDark ? AppColors.white : AppColors.neutral,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          bottomNavigationBar: CustomBottomNavBar(
            currentIndex: _currentNavIndex,
            onTap: _onNavTap,
          ),

          body: controller.isProcessing
              ? _buildProcessingState()
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
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

                      const SizedBox(height: 24),

                      _buildSectionTitle('Shipping Address', isDark),
                      const SizedBox(height: 12),
                      _buildAddressCard(isDark),

                      const SizedBox(height: 24),

                      _buildSectionTitle('Payment Method', isDark),
                      const SizedBox(height: 12),
                      _buildPaymentMethods(isDark),

                      const SizedBox(height: 24),

                      _buildSectionTitle('Order Summary', isDark),
                      const SizedBox(height: 12),
                      _buildOrderSummary(cartController, isDark),

                      const SizedBox(height: 24),

                      _buildPlaceOrderButton(cartController),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget _buildProcessingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.primary),
          const SizedBox(height: 16),
          Text(
            'Processing your order...',
            style: TextStyle(
              fontFamily: AppFonts.body,
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: AppFonts.headline,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.white : AppColors.neutral,
      ),
    );
  }

  Widget _buildAddressCard(bool isDark) {
    final address = controller.selectedAddress;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.location_on_outlined,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Default Address',
                    style: TextStyle(
                      fontFamily: AppFonts.label,
                      fontSize: 12,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  // TODO: Edit address
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.08)
                        : Colors.black.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Change',
                    style: TextStyle(
                      fontFamily: AppFonts.body,
                      fontSize: 13,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            address.name,
            style: TextStyle(
              fontFamily: AppFonts.headline,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.white : AppColors.neutral,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            address.address,
            style: TextStyle(
              fontFamily: AppFonts.body,
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),

          Text(
            address.city,
            style: TextStyle(
              fontFamily: AppFonts.body,
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            address.phone,
            style: TextStyle(
              fontFamily: AppFonts.body,
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethods(bool isDark) {
    return Column(
      children: controller.paymentMethods.map((method) {
        final isSelected = controller.selectedPaymentId == method.id;

        return GestureDetector(
          onTap: () => controller.selectPayment(method.id),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.06)
                  : Colors.black.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(16),
              border: isSelected
                  ? Border.all(color: AppColors.primary, width: 2)
                  : Border.all(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.05)
                          : Colors.black.withValues(alpha: 0.05),
                      width: 0.5,
                    ),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.08)
                        : Colors.black.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      method.icon,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Text(
                    method.name,
                    style: TextStyle(
                      fontFamily: AppFonts.headline,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.white : AppColors.neutral,
                    ),
                  ),
                ),

                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textSecondary,
                      width: 2,
                    ),
                    color: isSelected ? AppColors.primary : Colors.transparent,
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : null,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildOrderSummary(CartController cartController, bool isDark) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Items (${cartController.itemCount})',
                style: TextStyle(
                  fontFamily: AppFonts.body,
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Text(
                  'View Cart',
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

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(),
          ),

          _buildSummaryRow(
            'Subtotal',
            '\$${cartController.subtotal.toStringAsFixed(2)}',
            isDark,
          ),
          const SizedBox(height: 8),
          _buildSummaryRow(
            'Shipping',
            cartController.shipping == 0
                ? 'Free'
                : '\$${cartController.shipping.toStringAsFixed(2)}',
            isDark,
          ),
          const SizedBox(height: 8),
          _buildSummaryRow(
            'Tax',
            '\$${cartController.tax.toStringAsFixed(2)}',
            isDark,
          ),

          if (cartController.discount > 0) ...[
            const SizedBox(height: 8),
            _buildSummaryRow(
              'Discount',
              '-\$${cartController.discount.toStringAsFixed(2)}',
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
            '\$${cartController.total.toStringAsFixed(2)}',
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

  Widget _buildPlaceOrderButton(CartController cartController) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () async {
        await controller.placeOrder();

        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: isDark
                  ? Colors.black.withValues(alpha: 0.9)
                  : Colors.white.withValues(alpha: 0.95),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, color: AppColors.primary, size: 64),
                  const SizedBox(height: 16),
                  Text(
                    'Order Placed!',
                    style: TextStyle(
                      fontFamily: AppFonts.headline,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.neutral,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your order #${DateTime.now().millisecondsSinceEpoch.toString().substring(5)} has been placed successfully.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppFonts.body,
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        cartController.clearCart();
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/main',
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        'Continue Shopping',
                        style: TextStyle(
                          fontFamily: AppFonts.label,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
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
            'Place Order - \$${cartController.total.toStringAsFixed(2)}',
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
