// lib/core/theme/theme_dark.dart
import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/fonts.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.backgroundDark,
  primaryColor: AppColors.primary,
  
  // AppBar Theme
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.neutral,
    elevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(color: AppColors.white),
    titleTextStyle: TextStyle(
      fontFamily: AppFonts.headline,
      color: AppColors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
  
  // Bottom Nav Theme
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.neutral,
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
      color: AppColors.white,
    ),
    headlineMedium: TextStyle(
      fontFamily: AppFonts.headline,
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: AppColors.white,
    ),
    bodyLarge: TextStyle(
      fontFamily: AppFonts.body,
      fontSize: 16,
      color: AppColors.white,
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
    color: AppColors.neutralLight,
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  ),
);