// lib/views/profile/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/profile_controller.dart';
import '../../core/constants/colors.dart';

// Profile screen with sections and settings
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
        builder: (context, controller, _) {
          // Show login prompt if not logged in
          if (!controller.isLoggedIn) {
            return controller.buildLoginPrompt(isDark, context);
          }

          // Show profile content
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                // Profile header with avatar
                controller.buildProfileHeader(isDark, context),
                const SizedBox(height: 32),
                // Account section
                controller.buildAccountSection(isDark),
                const SizedBox(height: 24),
                // Orders section
                controller.buildOrdersSection(isDark),
                const SizedBox(height: 24),
                // Settings section
                controller.buildSettingsSection(isDark, context),
                const SizedBox(height: 24),
                // Support section
                controller.buildSupportSection(isDark),
                const SizedBox(height: 32),
                // Logout button
                controller.buildLogoutButton(isDark, context),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}