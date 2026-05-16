// lib/controllers/cart_controller.dart

import 'package:flutter/material.dart';
import '../models/cart_item.dart'; // ✅ الاسم الجديد

class CartController extends ChangeNotifier {
  List<CartItem> items = CartItem.sampleItems(); // ✅ CartItem
  String promoCode = '';
  double discount = 0;

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
  double get subtotal =>
      items.fold(0.0, (sum, item) => sum + item.totalPrice); // ✅ 0.0
  double get shipping => subtotal > 200 ? 0 : 15;
  double get tax => subtotal * 0.08;
  double get total => subtotal + shipping + tax - discount;

  void addItem(CartItem item) {
    // ✅ CartItem
    final existingIndex = items.indexWhere((i) => i.id == item.id);
    if (existingIndex >= 0) {
      items[existingIndex].quantity += item.quantity;
    } else {
      items.add(item);
    }
    notifyListeners();
  }

  void removeItem(String id) {
    items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void updateQuantity(String id, int delta) {
    final index = items.indexWhere((item) => item.id == id);
    if (index >= 0) {
      items[index].quantity += delta;
      if (items[index].quantity <= 0) {
        items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void applyPromo(String code) {
    promoCode = code;
    if (code.toUpperCase() == 'FITRA20') {
      discount = subtotal * 0.20;
    } else {
      discount = 0;
    }
    notifyListeners();
  }

  void clearCart() {
    items.clear();
    discount = 0;
    notifyListeners();
  }
}
