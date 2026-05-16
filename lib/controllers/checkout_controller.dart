// lib/controllers/checkout_controller.dart

import 'package:flutter/material.dart';
import '../models/checkout_model.dart';

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

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    isProcessing = false;
    notifyListeners();
  }
}
