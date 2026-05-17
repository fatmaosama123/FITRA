// lib/controllers/profile_controller.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../core/constants/colors.dart';
import '../core/constants/fonts.dart';
import 'theme_controller.dart';

class ProfileController extends ChangeNotifier {
  UserModel _user = UserModel.empty();
  bool _isLoading = false;
  int _currentNavIndex = 4;

  UserModel get user => _user;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _user.isLoggedIn;
  int get currentNavIndex => _currentNavIndex;

  final List<String> languages = [
    'English (US)',
    'العربية',
    'Français',
    'Español',
    'Deutsch',
  ];

  final List<Map<String, String>> currencies = [
    {'code': 'USD (\$)', 'name': 'United States Dollar'},
    {'code': 'EUR (€)', 'name': 'Euro'},
    {'code': 'GBP (£)', 'name': 'British Pound'},
    {'code': 'EGP (E£)', 'name': 'Egyptian Pound'},
    {'code': 'SAR (﷼)', 'name': 'Saudi Riyal'},
  ];

  String get userInitials {
    if (_user.name.isEmpty) return '';
    final nameParts = _user.name.split(' ');
    if (nameParts.length >= 2) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    }
    return _user.name[0].toUpperCase();
  }

  void onNavTap(BuildContext context, int index) {
    _currentNavIndex = index;
    notifyListeners();

    switch (index) {
      case 0:
        Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
        break;
      case 1:
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/category-details',
          (route) => false,
        );
        break;
      case 2:
        Navigator.pushNamed(context, '/try-on');
        break;
      case 3:
        Navigator.pushNamed(context, '/cart');
        break;
      case 4:
        break;
    }
  }

  void goBack(BuildContext context) => Navigator.pop(context);
  void goToLogin(BuildContext context) =>
      Navigator.pushNamed(context, '/login');
  void goToSignup(BuildContext context) =>
      Navigator.pushNamed(context, '/signup');

  void showLanguageSheet(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildBottomSheetWrapper(
        isDark: isDark,
        title: 'Select Language',
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: languages.map((lang) {
            final isSelected = _user.language == lang;
            return _buildSelectableItem(
              isDark: isDark,
              isSelected: isSelected,
              onTap: () {
                updateLanguage(lang);
                Navigator.pop(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    lang,
                    style: TextStyle(
                      fontFamily: AppFonts.body,
                      fontSize: 16,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: isDark ? AppColors.white : AppColors.neutral,
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_circle,
                      color: AppColors.primary,
                      size: 24,
                    ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  void showCurrencySheet(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildBottomSheetWrapper(
        isDark: isDark,
        title: 'Select Currency',
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: currencies.map((curr) {
            final isSelected = _user.currency == curr['code'];
            return _buildSelectableItem(
              isDark: isDark,
              isSelected: isSelected,
              onTap: () {
                updateCurrency(curr['code']!);
                Navigator.pop(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        curr['code']!,
                        style: TextStyle(
                          fontFamily: AppFonts.headline,
                          fontSize: 16,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                          color: isDark ? AppColors.white : AppColors.neutral,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        curr['name']!,
                        style: TextStyle(
                          fontFamily: AppFonts.body,
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_circle,
                      color: AppColors.primary,
                      size: 24,
                    ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  void showLogoutDialog(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: isDark ? AppColors.neutral : AppColors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.logout, color: AppColors.primary, size: 32),
            ),
            const SizedBox(height: 16),
            Text(
              'Log Out?',
              style: TextStyle(
                fontFamily: AppFonts.headline,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.white : AppColors.neutral,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Are you sure you want to log out of your account?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppFonts.body,
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildDialogButton(
                    isDark: isDark,
                    isPrimary: false,
                    label: 'Cancel',
                    onTap: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDialogButton(
                    isDark: isDark,
                    isPrimary: true,
                    label: 'Log Out',
                    onTap: () {
                      logout();
                      Navigator.pop(context);
                      goToLogin(context);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheetWrapper({
    required bool isDark,
    required String title,
    required Widget child,
  }) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.neutral : AppColors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(top: 12),
                    decoration: BoxDecoration(
                      color: AppColors.textSecondary.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontFamily: AppFonts.headline,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.white : AppColors.neutral,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [child, const SizedBox(height: 16)],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSelectableItem({
    required bool isDark,
    required bool isSelected,
    required VoidCallback onTap,
    required Widget child,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : (isDark ? AppColors.neutralLight : const Color(0xFFF8F8F8)),
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(color: AppColors.primary, width: 1)
              : null,
        ),
        child: child,
      ),
    );
  }

  Widget _buildDialogButton({
    required bool isDark,
    required bool isPrimary,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          gradient: isPrimary
              ? const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                )
              : null,
          color: isPrimary
              ? null
              : (isDark ? AppColors.neutralLight : const Color(0xFFF0F0F0)),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: AppFonts.label,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isPrimary
                  ? AppColors.white
                  : (isDark ? AppColors.white : AppColors.neutral),
            ),
          ),
        ),
      ),
    );
  }

  void loadUser({
    required String id,
    required String name,
    required String email,
    String? avatarUrl,
    String? phone,
  }) {
    _user = UserModel(
      id: id,
      name: name,
      email: email,
      avatarUrl: avatarUrl,
      phone: phone ?? '',
      memberType: 'Premium Member',
      addresses: [
        AddressModel(
          id: '1',
          name: name,
          address: '123 Main Street',
          city: 'New York, USA',
          phone: phone ?? '+1 234 567 890',
          isDefault: true,
        ),
      ],
      paymentMethods: [
        PaymentMethodModel(
          id: '1',
          name: 'Visa',
          icon: '💳',
          last4: '4242',
          isDefault: true,
        ),
      ],
    );
    notifyListeners();
  }

  void login(String email, String password) {
    _isLoading = true;
    notifyListeners();

    Future.delayed(const Duration(seconds: 1), () {
      loadUser(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        name: 'User Name',
        email: email,
        avatarUrl:
            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400&h=400&fit=crop&crop=face',
      );
      _isLoading = false;
      notifyListeners();
    });
  }

  void signup({
    required String fullName,
    required String email,
    required String password,
  }) {
    _isLoading = true;
    notifyListeners();

    Future.delayed(const Duration(seconds: 1), () {
      loadUser(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        name: fullName,
        email: email,
        avatarUrl:
            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400&h=400&fit=crop&crop=face',
      );
      _isLoading = false;
      notifyListeners();
    });
  }

  void updateLanguage(String language) {
    _user = _user.copyWith(language: language);
    notifyListeners();
  }

  void updateCurrency(String currency) {
    _user = _user.copyWith(currency: currency);
    notifyListeners();
  }

  void toggleDarkMode(BuildContext context, bool value) {
    _user = _user.copyWith(isDarkMode: value);
    notifyListeners();

    final themeController = context.read<ThemeController>();
    themeController.toggleTheme(value);
  }

  void updateProfile({
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
  }) {
    _user = _user.copyWith(
      name: name ?? _user.name,
      email: email ?? _user.email,
      phone: phone ?? _user.phone,
      avatarUrl: avatarUrl ?? _user.avatarUrl,
    );
    notifyListeners();
  }

  void logout() {
    _user = UserModel.empty();
    notifyListeners();
  }
}
