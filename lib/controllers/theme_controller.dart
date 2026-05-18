// lib/controllers/theme_controller.dart

// Flutter material package for ThemeMode
import 'package:flutter/material.dart';
// Shared preferences for saving theme
import 'package:shared_preferences/shared_preferences.dart';

// Manages app theme (dark/light) with persistence
class ThemeController extends ChangeNotifier {
  // Current theme mode (default light)
  ThemeMode _themeMode = ThemeMode.light;

  // Get current theme mode
  ThemeMode get themeMode => _themeMode;

  // Check if dark mode is active
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  // Constructor: load saved theme on create
  ThemeController() {
    _loadSavedTheme();
  }

  // Load theme from shared preferences
  Future<void> _loadSavedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('is_dark_mode') ?? false;
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  // Toggle and save theme mode
  Future<void> toggleTheme(bool isDark) async {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_dark_mode', isDark);
    notifyListeners();
  }
}