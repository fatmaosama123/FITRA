// lib/controllers/category_details_controller.dart

import 'package:flutter/material.dart';
import '../models/product_model.dart';

class CategoryDetailsController extends ChangeNotifier {
  String categoryName = '';
  String description = '';
  List<ProductModel> products = [];

  void init(String title) {
    categoryName = 'Curated $title';
    description =
        'Functional $title designed for the tactile curator. Minimal aesthetics, maximum durability.';
    products = ProductModel.getByCategory(title);
    notifyListeners();
  }
}
