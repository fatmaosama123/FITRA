// lib/controllers/profile_controller.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../core/constants/colors.dart';
import '../core/constants/fonts.dart';
import 'theme_controller.dart';

// Manages profile state, settings, and all UI builders
class ProfileController extends ChangeNotifier {

  // ─── User State ───

  UserModel _user = UserModel.empty();
  bool _isLoading = false;
  int _currentNavIndex = 4;

  // Getters
  UserModel get user => _user;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _user.isLoggedIn;
  int get currentNavIndex => _currentNavIndex;

  // ─── Settings Data ───

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

  // User initials from name
  String get userInitials {
    if (_user.name.isEmpty) return '';
    final nameParts = _user.name.split(' ');
    if (nameParts.length >= 2) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    }
    return _user.name[0].toUpperCase();
  }

  // ─── Navigation ───

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
  void goToLogin(BuildContext context) => Navigator.pushNamed(context, '/login');
  void goToSignup(BuildContext context) => Navigator.pushNamed(context, '/signup');
  void goToEditProfile(BuildContext context) => Navigator.pushNamed(context, '/edit-profile');

  // ─── UI BUILDERS ───

  // Build login prompt for guests
  Widget buildLoginPrompt(bool isDark, BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Guest icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.person_outline, size: 50, color: AppColors.primary),
              ),
              const SizedBox(height: 24),
              // Title
              _text('Welcome to FITRA', AppFonts.headline, 24,
                  isDark ? AppColors.white : AppColors.neutral,
                  bold: true),
              const SizedBox(height: 8),
              // Description
              _text(
                'Sign in to access your profile, orders, and saved preferences.',
                AppFonts.body,
                14,
                AppColors.textSecondary,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              // Sign in button
              _authButton(
                label: 'Sign In',
                isPrimary: true,
                onTap: () => goToLogin(context),
              ),
              const SizedBox(height: 12),
              // Sign up button
              _authButton(
                label: 'Create Account',
                isPrimary: false,
                isDark: isDark,
                onTap: () => goToSignup(context),
              ),
            ],
          ),
        ),
      );

  // Build profile header with avatar
  Widget buildProfileHeader(bool isDark, BuildContext context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: _cardDecoration(isDark),
        child: Row(
          children: [
            // Avatar
            _buildAvatar(),
            const SizedBox(width: 16),
            // User info
            Expanded(
              child: _buildUserInfo(isDark),
            ),
            // Edit button
            _editButton(isDark, () => goToEditProfile(context)),
          ],
        ),
      );

  // Build avatar image or initials
  Widget _buildAvatar() => Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: user.avatarUrl != null && user.avatarUrl!.isNotEmpty
              ? Image.network(
                  user.avatarUrl!,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _initialsAvatar(),
                  loadingBuilder: (_, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return _initialsAvatar();
                  },
                )
              : _initialsAvatar(),
        ),
      );

  // Build initials fallback avatar
  Widget _initialsAvatar() => Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.primaryDark],
          ),
        ),
        child: Center(
          child: _text(userInitials, AppFonts.headline, 24, AppColors.white,
              bold: true),
        ),
      );

  // Build user name, email, and badge
  Widget _buildUserInfo(bool isDark) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _text(user.name, AppFonts.headline, 20,
              isDark ? AppColors.white : AppColors.neutral,
              bold: true),
          const SizedBox(height: 4),
          _text(user.email, AppFonts.body, 14, AppColors.textSecondary),
          const SizedBox(height: 8),
          // Member type badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: _text(user.memberType, AppFonts.label, 12, AppColors.primary,
                bold: true),
          ),
        ],
      );

  // Build edit button
  Widget _editButton(bool isDark, VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDark ? AppColors.neutralLight : const Color(0xFFF0F0F0),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.edit_outlined,
            size: 20,
            color: isDark ? AppColors.white : AppColors.neutral,
          ),
        ),
      );

  // Build account section
  Widget buildAccountSection(bool isDark) => _buildSection(
        title: 'Account',
        isDark: isDark,
        items: [
          _menuItem(
            icon: Icons.person_outline,
            title: 'Personal Information',
            subtitle: user.name,
            isDark: isDark,
            onTap: () {},
          ),
          _menuItem(
            icon: Icons.location_on_outlined,
            title: 'Addresses',
            subtitle:
                '${user.addresses.length} saved address${user.addresses.length != 1 ? 'es' : ''}',
            isDark: isDark,
            onTap: () {},
          ),
          _menuItem(
            icon: Icons.payment_outlined,
            title: 'Payment Methods',
            subtitle:
                '${user.paymentMethods.length} card${user.paymentMethods.length != 1 ? 's' : ''}',
            isDark: isDark,
            onTap: () {},
          ),
        ],
      );

  // Build orders section
  Widget buildOrdersSection(bool isDark) => _buildSection(
        title: 'Orders',
        isDark: isDark,
        items: [
          _menuItem(
            icon: Icons.shopping_bag_outlined,
            title: 'Order History',
            subtitle: 'View your past orders',
            isDark: isDark,
            onTap: () {},
          ),
          _menuItem(
            icon: Icons.local_shipping_outlined,
            title: 'Track Order',
            subtitle: 'Track your current orders',
            isDark: isDark,
            onTap: () {},
          ),
        ],
      );

  // Build settings section
  Widget buildSettingsSection(bool isDark, BuildContext context) => _buildSection(
        title: 'Settings',
        isDark: isDark,
        items: [
          // Notifications with badge
          _menuItem(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            subtitle: 'Manage notification preferences',
            isDark: isDark,
            onTap: () => Navigator.pushNamed(context, '/notifications'),
          ),
          // Language
          _menuItem(
            icon: Icons.language_outlined,
            title: 'Language',
            subtitle: user.language,
            isDark: isDark,
            onTap: () => showLanguageSheet(context, isDark),
          ),
          // Dark mode toggle
          _menuItem(
            icon: user.isDarkMode
                ? Icons.light_mode_outlined
                : Icons.dark_mode_outlined,
            title: 'Dark Mode',
            subtitle: user.isDarkMode ? 'On' : 'Off',
            isDark: isDark,
            onTap: () => toggleDarkMode(context, !user.isDarkMode),
            trailing: Switch(
              value: user.isDarkMode,
              onChanged: (value) => toggleDarkMode(context, value),
              activeColor: AppColors.primary,
            ),
          ),
          // Currency
          _menuItem(
            icon: Icons.currency_exchange_outlined,
            title: 'Currency',
            subtitle: user.currency,
            isDark: isDark,
            onTap: () => showCurrencySheet(context, isDark),
          ),
        ],
      );

  // Build support section
  Widget buildSupportSection(bool isDark) => _buildSection(
        title: 'Support',
        isDark: isDark,
        items: [
          _menuItem(
            icon: Icons.help_outline,
            title: 'Help Center',
            subtitle: 'FAQs and support articles',
            isDark: isDark,
            onTap: () {},
          ),
          _menuItem(
            icon: Icons.chat_bubble_outline,
            title: 'Contact Us',
            subtitle: 'Get in touch with our team',
            isDark: isDark,
            onTap: () {},
          ),
          _menuItem(
            icon: Icons.policy_outlined,
            title: 'Privacy Policy',
            subtitle: 'Read our privacy policy',
            isDark: isDark,
            onTap: () {},
          ),
        ],
      );

  // Build logout button
  Widget buildLogoutButton(bool isDark, BuildContext context) => GestureDetector(
        onTap: () => showLogoutDialog(context, isDark),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: isDark ? AppColors.neutral : AppColors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.logout, color: AppColors.primary, size: 20),
                const SizedBox(width: 8),
                _text('Log Out', AppFonts.label, 16, AppColors.primary,
                    bold: true),
              ],
            ),
          ),
        ),
      );

  // ─── BOTTOM SHEETS & DIALOGS ───

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
            return _selectableItem(
              isDark: isDark,
              isSelected: isSelected,
              onTap: () {
                updateLanguage(lang);
                Navigator.pop(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _text(lang, AppFonts.body, 16,
                      isDark ? AppColors.white : AppColors.neutral,
                      bold: isSelected),
                  if (isSelected)
                    Icon(Icons.check_circle, color: AppColors.primary, size: 24),
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
            return _selectableItem(
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
                      _text(curr['code']!, AppFonts.headline, 16,
                          isDark ? AppColors.white : AppColors.neutral,
                          bold: isSelected),
                      const SizedBox(height: 2),
                      _text(curr['name']!, AppFonts.body, 13,
                          AppColors.textSecondary),
                    ],
                  ),
                  if (isSelected)
                    Icon(Icons.check_circle, color: AppColors.primary, size: 24),
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
            // Logout icon
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
            // Title
            _text('Log Out?', AppFonts.headline, 24,
                isDark ? AppColors.white : AppColors.neutral,
                bold: true),
            const SizedBox(height: 8),
            // Message
            _text(
              'Are you sure you want to log out of your account?',
              AppFonts.body,
              14,
              AppColors.textSecondary,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            // Buttons
            Row(
              children: [
                Expanded(
                  child: _dialogButton(
                    isDark: isDark,
                    isPrimary: false,
                    label: 'Cancel',
                    onTap: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _dialogButton(
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

  // ─── PRIVATE HELPERS ───

  // Reusable card decoration
  BoxDecoration _cardDecoration(bool isDark) => BoxDecoration(
        color: isDark ? AppColors.neutral : AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      );

  // Build section with title and items
  Widget _buildSection({
    required String title,
    required bool isDark,
    required List<Widget> items,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _text(title, AppFonts.headline, 18,
              isDark ? AppColors.white : AppColors.neutral,
              bold: true),
          const SizedBox(height: 12),
          Container(
            decoration: _cardDecoration(isDark),
            child: Column(children: items),
          ),
        ],
      );

  // Build menu item row
  Widget _menuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDark,
    required VoidCallback onTap,
    Widget? trailing,
  }) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isDark ? AppColors.neutralLight : const Color(0xFFF0F0F0),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              // Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.neutralLight
                      : AppColors.backgroundLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 20, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _text(title, AppFonts.headline, 15,
                        isDark ? AppColors.white : AppColors.neutral,
                        bold: true),
                    const SizedBox(height: 2),
                    _text(subtitle, AppFonts.body, 13, AppColors.textSecondary),
                  ],
                ),
              ),
              // Trailing or arrow
              trailing ??
                  const Icon(Icons.arrow_forward_ios,
                      size: 16, color: AppColors.textSecondary),
            ],
          ),
        ),
      );

  // Auth button (login/signup)
  Widget _authButton({
    required String label,
    required bool isPrimary,
    bool? isDark,
    required VoidCallback onTap,
  }) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            gradient: isPrimary
                ? const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                  )
                : null,
            color: isPrimary
                ? null
                : (isDark == true ? AppColors.neutral : AppColors.white),
            borderRadius: BorderRadius.circular(28),
            border: isPrimary
                ? null
                : Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    width: 1,
                  ),
          ),
          child: Center(
            child: _text(
              label,
              AppFonts.label,
              16,
              isPrimary ? AppColors.white : AppColors.primary,
              bold: true,
            ),
          ),
        ),
      );

  // Bottom sheet wrapper
  Widget _buildBottomSheetWrapper({
    required bool isDark,
    required String title,
    required Widget child,
  }) =>
      DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.neutral : AppColors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag handle
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
                // Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _text(title, AppFonts.headline, 24,
                      isDark ? AppColors.white : AppColors.neutral,
                      bold: true),
                ),
                const SizedBox(height: 20),
                // Content
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
        ),
      );

  // Selectable item in bottom sheet
  Widget _selectableItem({
    required bool isDark,
    required bool isSelected,
    required VoidCallback onTap,
    required Widget child,
  }) =>
      GestureDetector(
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

  // Dialog action button
  Widget _dialogButton({
    required bool isDark,
    required bool isPrimary,
    required String label,
    required VoidCallback onTap,
  }) =>
      GestureDetector(
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
            child: _text(
              label,
              AppFonts.label,
              16,
              isPrimary
                  ? AppColors.white
                  : (isDark ? AppColors.white : AppColors.neutral),
              bold: true,
            ),
          ),
        ),
      );

  // Quick text widget
  Widget _text(
    String text,
    String font,
    double size,
    Color color, {
    bool bold = false,
    TextAlign? textAlign,
  }) =>
      Text(
        text,
        textAlign: textAlign,
        style: _textStyle(font, size, color, bold: bold),
      );

  // Text style helper
  TextStyle _textStyle(
    String font,
    double size,
    Color color, {
    bool bold = false,
  }) =>
      TextStyle(
        fontFamily: font,
        fontSize: size,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        color: color,
      );

  // ─── USER ACTIONS ───

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