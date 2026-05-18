// lib/controllers/navigation_controller.dart

// Flutter material package for ChangeNotifier
import 'package:flutter/material.dart';

// Manages bottom navigation state
class NavigationController extends ChangeNotifier {
  // Current selected tab index
  int _currentIndex = 0;

  // Get current tab index
  int get currentIndex => _currentIndex;

  // Change active tab safely
  void changeTab(int index) {
    if (_currentIndex != index) {
      _currentIndex = index;
      // Use addPostFrameCallback to avoid calling during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }
}