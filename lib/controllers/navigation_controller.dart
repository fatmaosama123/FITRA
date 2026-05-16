// lib/controllers/navigation_controller.dart
import 'package:flutter/material.dart';

class NavigationController extends ChangeNotifier {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  void changeTab(int index) {
    if (_currentIndex != index) {
      _currentIndex = index;
      // ✅ نستخدم addPostFrameCallback عشان مايتناداش during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }
}
