// lib/views/profile/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/profile_controller.dart';
import '../../controllers/inbox_controller.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/fonts.dart';
import '../../routes/app_routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      body: Consumer<ProfileController>(
        builder: (context, controller, child) {
          final user = controller.user;

          if (!controller.isLoggedIn) {
            return _buildLoginPrompt(context, controller, isDark);
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                _buildProfileHeader(controller, isDark, context),
                const SizedBox(height: 32),

                _buildSectionTitle('Account', isDark),
                const SizedBox(height: 12),
                _buildCardContainer(
                  isDark: isDark,
                  itemsList: [
                    _buildMenuItem(
                      icon: Icons.person_outline,
                      title: 'Personal Information',
                      subtitle: user.name,
                      isDark: isDark,
                      onTap: () {},
                    ),
                    _buildMenuItem(
                      icon: Icons.location_on_outlined,
                      title: 'Addresses',
                      subtitle:
                          '${user.addresses.length} saved address${user.addresses.length != 1 ? 'es' : ''}',
                      isDark: isDark,
                      onTap: () {},
                    ),
                    _buildMenuItem(
                      icon: Icons.payment_outlined,
                      title: 'Payment Methods',
                      subtitle:
                          '${user.paymentMethods.length} card${user.paymentMethods.length != 1 ? 's' : ''}',
                      isDark: isDark,
                      onTap: () {},
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                _buildSectionTitle('Orders', isDark),
                const SizedBox(height: 12),
                _buildCardContainer(
                  isDark: isDark,
                  itemsList: [
                    _buildMenuItem(
                      icon: Icons.shopping_bag_outlined,
                      title: 'Order History',
                      subtitle: 'View your past orders',
                      isDark: isDark,
                      onTap: () {},
                    ),
                    _buildMenuItem(
                      icon: Icons.local_shipping_outlined,
                      title: 'Track Order',
                      subtitle: 'Track your current orders',
                      isDark: isDark,
                      onTap: () {},
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                _buildSectionTitle('Settings', isDark),
                const SizedBox(height: 12),
                _buildCardContainer(
                  isDark: isDark,
                  itemsList: [
                    Consumer<InboxController>(
                      builder: (context, inboxController, child) {
                        return _buildMenuItem(
                          icon: Icons.notifications_outlined,
                          title: 'Notifications',
                          subtitle: inboxController.hasUnread
                              ? '${inboxController.unreadCount} unread'
                              : 'Manage notification preferences',
                          isDark: isDark,
                          onTap: () =>
                              Navigator.pushNamed(context, '/notifications'),
                          trailing: inboxController.hasUnread
                              ? Container(
                                  width: 24,
                                  height: 24,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFFF6B6B),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${inboxController.unreadCount}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                )
                              : const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: AppColors.textSecondary,
                                ),
                        );
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.language_outlined,
                      title: 'Language',
                      subtitle: user.language,
                      isDark: isDark,
                      onTap: () =>
                          controller.showLanguageSheet(context, isDark),
                    ),
                    _buildMenuItem(
                      icon: user.isDarkMode
                          ? Icons.light_mode_outlined
                          : Icons.dark_mode_outlined,
                      title: 'Dark Mode',
                      subtitle: user.isDarkMode ? 'On' : 'Off',
                      isDark: isDark,
                      onTap: () {
                        controller.toggleDarkMode(context, !user.isDarkMode);
                      },
                      trailing: Switch(
                        value: user.isDarkMode,
                        onChanged: (value) {
                          controller.toggleDarkMode(context, value);
                        },
                        activeColor: AppColors.primary,
                      ),
                    ),
                    _buildMenuItem(
                      icon: Icons.currency_exchange_outlined,
                      title: 'Currency',
                      subtitle: user.currency,
                      isDark: isDark,
                      onTap: () =>
                          controller.showCurrencySheet(context, isDark),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                _buildSectionTitle('Support', isDark),
                const SizedBox(height: 12),
                _buildCardContainer(
                  isDark: isDark,
                  itemsList: [
                    _buildMenuItem(
                      icon: Icons.help_outline,
                      title: 'Help Center',
                      subtitle: 'FAQs and support articles',
                      isDark: isDark,
                      onTap: () {},
                    ),
                    _buildMenuItem(
                      icon: Icons.chat_bubble_outline,
                      title: 'Contact Us',
                      subtitle: 'Get in touch with our team',
                      isDark: isDark,
                      onTap: () {},
                    ),
                    _buildMenuItem(
                      icon: Icons.policy_outlined,
                      title: 'Privacy Policy',
                      subtitle: 'Read our privacy policy',
                      isDark: isDark,
                      onTap: () {},
                    ),
                  ],
                ),

                const SizedBox(height: 32),
                _buildLogoutButton(isDark, controller, context),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoginPrompt(
    BuildContext context,
    ProfileController controller,
    bool isDark,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person_outline,
                size: 50,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Welcome to FITRA',
              style: TextStyle(
                fontFamily: AppFonts.headline,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.white : AppColors.neutral,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Sign in to access your profile, orders, and saved preferences.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppFonts.body,
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 32),
            _buildAuthButton(
              label: 'Sign In',
              isPrimary: true,
              onTap: () => controller.goToLogin(context),
            ),
            const SizedBox(height: 12),
            _buildAuthButton(
              label: 'Create Account',
              isPrimary: false,
              isDark: isDark,
              onTap: () => controller.goToSignup(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthButton({
    required String label,
    required bool isPrimary,
    bool? isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
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
          child: Text(
            label,
            style: TextStyle(
              fontFamily: AppFonts.label,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isPrimary ? AppColors.white : AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(
    ProfileController controller,
    bool isDark,
    BuildContext context,
  ) {
    final user = controller.user;
    final initials = controller.userInitials;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.neutral : AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
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
                      errorBuilder: (context, error, stackTrace) {
                        return _buildInitialsAvatar(initials);
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return _buildInitialsAvatar(initials);
                      },
                    )
                  : _buildInitialsAvatar(initials),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: TextStyle(
                    fontFamily: AppFonts.headline,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.white : AppColors.neutral,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  style: TextStyle(
                    fontFamily: AppFonts.body,
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    user.memberType,
                    style: TextStyle(
                      fontFamily: AppFonts.label,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              AppRoutes.goToEditProfile(context);
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.neutralLight
                    : const Color(0xFFF0F0F0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.edit_outlined,
                size: 20,
                color: isDark ? AppColors.white : AppColors.neutral,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialsAvatar(String initials) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
      ),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            fontFamily: AppFonts.headline,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: AppFonts.headline,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.white : AppColors.neutral,
      ),
    );
  }

  Widget _buildCardContainer({
    required bool isDark,
    required List<Widget> itemsList,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.neutral : AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: itemsList),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDark,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return GestureDetector(
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: AppFonts.headline,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.white : AppColors.neutral,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: AppFonts.body,
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            trailing ??
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(
    bool isDark,
    ProfileController controller,
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: () => controller.showLogoutDialog(context, isDark),
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
              Text(
                'Log Out',
                style: TextStyle(
                  fontFamily: AppFonts.label,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
