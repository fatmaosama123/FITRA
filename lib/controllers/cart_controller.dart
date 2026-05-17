// lib/controllers/cart_controller.dart

import 'package:flutter/material.dart';
import '../models/cart_item.dart';

class CartController extends ChangeNotifier {
  List<CartItem> _items = CartItem.sampleItems();

  List<CartItem> get items => _items;
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  double get subtotal => _items.fold(0, (sum, item) => sum + item.totalPrice);
  double get shipping => subtotal > 150 ? 0 : 15;
  double get tax => subtotal * 0.08;
  double get discount => _discount;
  double get total => subtotal + shipping + tax - discount;

  double _discount = 0;

  void addItem(CartItem item) {
    final existingIndex = _items.indexWhere((i) => i.id == item.id);
    if (existingIndex >= 0) {
      _items[existingIndex].quantity += item.quantity;
    } else {
      _items.add(item);
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void updateQuantity(String id, int change) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index >= 0) {
      _items[index].quantity += change;
      if (_items[index].quantity <= 0) {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void applyPromo(String code) {
    if (code.toUpperCase() == 'FITRA20') {
      _discount = subtotal * 0.2;
    } else {
      _discount = 0;
    }
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    _discount = 0;
    notifyListeners();
  }
}
