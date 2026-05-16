// lib/controllers/try_on_controller.dart

import 'package:flutter/material.dart';
import '../models/try_on_model.dart';

class TryOnController extends ChangeNotifier {
  String? uploadedImagePath;
  bool isUploading = false;
  TryOnProduct? selectedProduct;

  final List<TryOnProduct> recommendedProducts = TryOnProduct.getRecommended();

  void uploadPhoto() {
    isUploading = true;
    notifyListeners();

    Future.delayed(const Duration(seconds: 1), () {
      uploadedImagePath =
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=600&fit=crop';
      isUploading = false;
      notifyListeners();
    });
  }

  void selectProduct(TryOnProduct product) {
    selectedProduct = product;
    notifyListeners();
  }

  void tryItOn() {
    // TODO: Implement AI try-on logic
  }
}
