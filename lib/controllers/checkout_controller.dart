// lib/controllers/checkout_controller.dart

import 'package:flutter/material.dart';
import '../models/checkout_model.dart';
import '../core/constants/colors.dart';
import '../core/constants/fonts.dart';
import 'cart_controller.dart';

class CheckoutController extends ChangeNotifier {
  List<PaymentMethod> paymentMethods = PaymentMethod.getMethods();
  List<ShippingAddress> addresses = ShippingAddress.getAddresses();

  String selectedPaymentId = 'cash';
  String selectedAddressId = '1';
  bool isProcessing = false;

  PaymentMethod get selectedPayment =>
      paymentMethods.firstWhere((p) => p.id == selectedPaymentId);

  ShippingAddress get selectedAddress =>
      addresses.firstWhere((a) => a.id == selectedAddressId);

  void selectPayment(String id) {
    selectedPaymentId = id;
    notifyListeners();
  }

  void selectAddress(String id) {
    selectedAddressId = id;
    notifyListeners();
  }

  void addAddress(ShippingAddress address) {
    addresses.add(address);
    notifyListeners();
  }

  Future<void> placeOrder() async {
    isProcessing = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 2));
    isProcessing = false;
    notifyListeners();
  }

  // ─── UI BUILDERS ───

  Widget buildProcessingState() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppColors.primary),
            const SizedBox(height: 16),
            _text('Processing your order...', AppFonts.body, 16,
                AppColors.textSecondary),
          ],
        ),
      );

  Widget buildSectionTitle(String title, bool isDark) => Text(
        title,
        style: _textStyle(
          AppFonts.headline,
          18,
          isDark ? AppColors.white : AppColors.neutral,
          bold: true,
        ),
      );

  Widget buildAddressCard(bool isDark) {
    final address = selectedAddress;
    return _card(
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _iconContainer(
                    icon: Icons.location_on_outlined,
                    color: AppColors.primary,
                    bgColor: AppColors.primary.withValues(alpha: 0.12),
                  ),
                  const SizedBox(width: 8),
                  _text('Default Address', AppFonts.label, 12, AppColors.primary,
                      bold: true),
                ],
              ),
              _changeButton(isDark),
            ],
          ),
          const SizedBox(height: 12),
          _text(address.name, AppFonts.headline, 16,
              isDark ? AppColors.white : AppColors.neutral,
              bold: true),
          const SizedBox(height: 4),
          _text(address.address, AppFonts.body, 14, AppColors.textSecondary),
          _text(address.city, AppFonts.body, 14, AppColors.textSecondary),
          const SizedBox(height: 4),
          _text(address.phone, AppFonts.body, 13, AppColors.textSecondary),
        ],
      ),
    );
  }

  Widget buildPaymentMethods(bool isDark) {
    return Column(
      children: paymentMethods.map((method) {
        final isSelected = selectedPaymentId == method.id;
        return GestureDetector(
          onTap: () => selectPayment(method.id),
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
                // FIXED: Added color parameter (transparent since we use emoji)
                _iconContainer(
                  iconWidget: Text(method.icon, style: const TextStyle(fontSize: 24)),
                  color: Colors.transparent, // FIXED
                  bgColor: isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.black.withValues(alpha: 0.05),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _text(method.name, AppFonts.headline, 16,
                      isDark ? AppColors.white : AppColors.neutral,
                      bold: true),
                ),
                _radioIndicator(isSelected),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget buildOrderSummary(CartController cart, bool isDark, VoidCallback onViewCart) {
    return _card(
      isDark: isDark,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _text('Items (${cart.itemCount})', AppFonts.body, 14,
                  AppColors.textSecondary),
              GestureDetector(
                onTap: onViewCart,
                child: _text('View Cart', AppFonts.body, 14, AppColors.primary,
                    bold: true),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(),
          ),
          _summaryRow('Subtotal', '\$${cart.subtotal.toStringAsFixed(2)}', isDark),
          const SizedBox(height: 8),
          _summaryRow(
            'Shipping',
            cart.shipping == 0 ? 'Free' : '\$${cart.shipping.toStringAsFixed(2)}',
            isDark,
          ),
          const SizedBox(height: 8),
          _summaryRow('Tax', '\$${cart.tax.toStringAsFixed(2)}', isDark),
          if (cart.discount > 0) ...[
            const SizedBox(height: 8),
            _summaryRow(
              'Discount',
              '-\$${cart.discount.toStringAsFixed(2)}',
              isDark,
              color: AppColors.primary,
            ),
          ],
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(),
          ),
          _summaryRow('Total', '\$${cart.total.toStringAsFixed(2)}', isDark,
              isTotal: true),
        ],
      ),
    );
  }

  Widget buildPlaceOrderButton(
    CartController cart,
    bool isDark,
    VoidCallback onPlaceOrder,
  ) {
    return GestureDetector(
      onTap: onPlaceOrder,
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
          ],
        ),
        child: Center(
          child: _text(
            'Place Order - \$${cart.total.toStringAsFixed(2)}',
            AppFonts.label,
            16,
            Colors.white,
            bold: true,
          ),
        ),
      ),
    );
  }

  Widget buildSuccessDialog(bool isDark, String orderNumber, VoidCallback onContinue) {
    return AlertDialog(
      backgroundColor: isDark
          ? Colors.black.withValues(alpha: 0.9)
          : Colors.white.withValues(alpha: 0.95),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, color: AppColors.primary, size: 64),
          const SizedBox(height: 16),
          _text('Order Placed!', AppFonts.headline, 24,
              isDark ? Colors.white : AppColors.neutral,
              bold: true),
          const SizedBox(height: 8),
          Text(
            'Your order #$orderNumber has been placed successfully.',
            textAlign: TextAlign.center,
            style: _textStyle(AppFonts.body, 14, AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _text('Continue Shopping', AppFonts.label, 16,
                  AppColors.white, bold: true),
            ),
          ),
        ],
      ),
    );
  }

  // ─── PRIVATE HELPERS ───

  Widget _card({required bool isDark, required Widget child}) => Container(
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
        child: child,
      );

  Widget _iconContainer({
    IconData? icon,
    Widget? iconWidget,
    required Color color,
    required Color bgColor,
  }) =>
      Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: iconWidget ?? Icon(icon, color: color, size: 20),
      );

  Widget _changeButton(bool isDark) => GestureDetector(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: _text('Change', AppFonts.body, 13, AppColors.primary,
              bold: true),
        ),
      );

  Widget _radioIndicator(bool isSelected) => Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.textSecondary,
            width: 2,
          ),
          color: isSelected ? AppColors.primary : Colors.transparent,
        ),
        child: isSelected
            ? const Icon(Icons.check, size: 16, color: Colors.white)
            : null,
      );

  Widget _summaryRow(
    String label,
    String value,
    bool isDark, {
    bool isTotal = false,
    Color? color,
  }) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _text(
            label,
            isTotal ? AppFonts.headline : AppFonts.body,
            isTotal ? 18 : 14,
            isDark ? AppColors.white : AppColors.neutral,
            bold: isTotal,
          ),
          _text(
            value,
            isTotal ? AppFonts.headline : AppFonts.body,
            isTotal ? 24 : 14,
            color ??
                (isTotal
                    ? (isDark ? AppColors.white : AppColors.neutral)
                    : AppColors.textSecondary),
            bold: isTotal,
          ),
        ],
      );

  Widget _text(String text, String font, double size, Color color,
          {bool bold = false}) =>
      Text(
        text,
        style: _textStyle(font, size, color, bold: bold),
      );

  TextStyle _textStyle(String font, double size, Color color,
          {bool bold = false}) =>
      TextStyle(
        fontFamily: font,
        fontSize: size,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        color: color,
      );
}