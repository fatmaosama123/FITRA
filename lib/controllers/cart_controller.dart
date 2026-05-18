// lib/controllers/cart_controller.dart

import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../core/constants/colors.dart';
import '../core/constants/fonts.dart';

// Extension for cart calculations
extension CartCalculations on List<CartItem> {
  int get totalQty => fold(0, (s, i) => s + i.quantity);
  double get subtotal => fold(0, (s, i) => s + i.totalPrice);
}

class CartController extends ChangeNotifier {
  List<CartItem> _items = CartItem.samples;

  List<CartItem> get items => _items;
  int get itemCount => _items.totalQty;
  double get subtotal => _items.subtotal;
  double get shipping => subtotal > 150 ? 0 : 15;
  double get tax => subtotal * 0.08;
  double get total => subtotal + shipping + tax - _discount;
  double get discount => _discount;

  double _discount = 0;

  void addItem(CartItem item) {
    final idx = _items.indexWhere((i) => i.id == item.id);
    if (idx >= 0) {
      _items[idx].quantity += item.quantity;
    } else {
      _items.add(item);
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.removeWhere((i) => i.id == id);
    notifyListeners();
  }

  void updateQuantity(String id, int change) {
    final idx = _items.indexWhere((i) => i.id == id);
    if (idx < 0) return;
    final newQty = _items[idx].quantity + change;
    if (newQty <= 0) {
      _items.removeAt(idx);
    } else {
      _items[idx].quantity = newQty;
    }
    notifyListeners();
  }

  void applyPromo(String code) {
    _discount = code.toUpperCase() == 'FITRA20' ? subtotal * 0.2 : 0;
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    _discount = 0;
    notifyListeners();
  }

  // ─── UI BUILDERS ───

  // Build empty cart state
  Widget buildEmptyState(bool isDark) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 80,
              color: AppColors.textSecondary.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            _text('Your cart is empty', AppFonts.headline, 20,
                isDark ? AppColors.white : AppColors.textSecondary),
            const SizedBox(height: 8),
            _text('Start curating your wardrobe', AppFonts.body, 14,
                AppColors.textSecondary),
          ],
        ),
      );

  // Build single cart item card
  Widget buildCartItem(CartItem item, bool isDark, BuildContext context) {
    return _card(
      isDark: isDark,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              item.imageUrl,
              width: 100,
              height: 120,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 100,
                height: 120,
                color: AppColors.secondary,
                child: Icon(
                  Icons.image_not_supported,
                  color: AppColors.textSecondary.withValues(alpha: 0.5),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Product details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name and remove button
                Row(
                  children: [
                    Expanded(
                      child: _text(
                        item.name,
                        AppFonts.headline,
                        16,
                        isDark ? AppColors.white : AppColors.neutral,
                        bold: true,
                      ),
                    ),
                    _iconBtn(
                      icon: Icons.close,
                      onTap: () => removeItem(item.id),
                      isDark: isDark,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Size info
                _infoText('Size: ${item.size}'),
                // Color info
                _infoText('Color: ${item.color}'),
                const SizedBox(height: 12),
                // Quantity and price row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _qtySelector(
                      qty: item.quantity,
                      onMinus: () => updateQuantity(item.id, -1),
                      onPlus: () => updateQuantity(item.id, 1),
                      isDark: isDark,
                    ),
                    Flexible(
                      child: _text(
                        '\$${item.totalPrice.toStringAsFixed(2)}',
                        AppFonts.headline,
                        16,
                        AppColors.primary,
                        bold: true,
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

  // Build promo code input section
  Widget buildPromoCode(bool isDark, TextEditingController controller) {
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
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Enter promo code',
                hintStyle: _textStyle(AppFonts.body, 14, AppColors.textSecondary),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => applyPromo(controller.text),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.neutral,
                borderRadius: BorderRadius.circular(24),
              ),
              child: _text('Apply', AppFonts.label, 14, AppColors.white, bold: true),
            ),
          ),
        ],
      ),
    );
  }

  // Build order summary section
  Widget buildSummary(bool isDark) {
    return _card(
      isDark: isDark,
      child: Column(
        children: [
          _summaryRow('Subtotal', '\$${subtotal.toStringAsFixed(2)}', isDark),
          const SizedBox(height: 8),
          _summaryRow(
            'Shipping',
            shipping == 0 ? 'Free' : '\$${shipping.toStringAsFixed(2)}',
            isDark,
          ),
          const SizedBox(height: 8),
          _summaryRow('Estimated Tax', '\$${tax.toStringAsFixed(2)}', isDark),
          if (_discount > 0) ...[
            const SizedBox(height: 8),
            _summaryRow(
              'Discount',
              '-\$${_discount.toStringAsFixed(2)}',
              isDark,
              color: AppColors.primary,
            ),
          ],
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(),
          ),
          _summaryRow('Total', '\$${total.toStringAsFixed(2)}', isDark, isTotal: true),
        ],
      ),
    );
  }

  // Build checkout button
  Widget buildCheckoutButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_items.isNotEmpty) {
          Navigator.pushNamed(context, '/checkout');
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
          child: _text(
            'Proceed to Checkout',
            AppFonts.label,
            16,
            Colors.white,
            bold: true,
          ),
        ),
      ),
    );
  }

  // ─── PRIVATE HELPERS ───

  // Reusable card container
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

  // Circular icon button
  Widget _iconBtn({
    required IconData icon,
    required VoidCallback onTap,
    required bool isDark,
  }) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.05),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 16, color: AppColors.textSecondary),
        ),
      );

  // Quantity selector
  Widget _qtySelector({
    required int qty,
    required VoidCallback onMinus,
    required VoidCallback onPlus,
    required bool isDark,
  }) =>
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
              onPressed: onMinus,
            ),
            _text('$qty', AppFonts.label, 14,
                isDark ? AppColors.white : AppColors.neutral,
                bold: true),
            IconButton(
              icon: Icon(
                Icons.add,
                size: 18,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
              onPressed: onPlus,
            ),
          ],
        ),
      );

  // Summary row widget
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

  // Info text (size, color)
  Widget _infoText(String text) => Text(
        text,
        style: _textStyle(AppFonts.body, 13, AppColors.textSecondary),
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