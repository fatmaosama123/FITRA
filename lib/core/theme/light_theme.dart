// lib/core/theme/light_theme.dart
import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/fonts.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: AppColors.backgroundLight,
  primaryColor: AppColors.primary,
  
  // AppBar Theme
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.white,
    elevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(color: AppColors.neutral),
    titleTextStyle: TextStyle(
      fontFamily: AppFonts.headline,
      color: AppColors.neutral,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
  
  // Bottom Nav Theme
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.white,
    selectedItemColor: AppColors.primary,
    unselectedItemColor: AppColors.textSecondary,
    type: BottomNavigationBarType.fixed,
    showSelectedLabels: true,
    showUnselectedLabels: true,
    selectedLabelStyle: TextStyle(
      fontFamily: AppFonts.label,
      fontSize: 12,
      fontWeight: FontWeight.w500,
    ),
    unselectedLabelStyle: TextStyle(
      fontFamily: AppFonts.label,
      fontSize: 12,
    ),
  ),
  
  // Text Theme
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      fontFamily: AppFonts.headline,
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary,
    ),
    headlineMedium: TextStyle(
      fontFamily: AppFonts.headline,
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary,
    ),
    bodyLarge: TextStyle(
      fontFamily: AppFonts.body,
      fontSize: 16,
      color: AppColors.textPrimary,
    ),
    bodyMedium: TextStyle(
      fontFamily: AppFonts.body,
      fontSize: 14,
      color: AppColors.textSecondary,
    ),
    labelMedium: TextStyle(
      fontFamily: AppFonts.label,
      fontSize: 12,
      fontWeight: FontWeight.w500,
    ),
  ),
  
  // Elevated Button Theme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      textStyle: const TextStyle(
        fontFamily: AppFonts.label,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
  
  // ✅ Card ThemeData (مش CardTheme)
  cardTheme: const CardThemeData(
    color: AppColors.white,
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  ),
);