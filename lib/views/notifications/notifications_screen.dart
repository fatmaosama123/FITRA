// lib/views/notifications/notifications_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/inbox_controller.dart';
import '../../core/constants/colors.dart';
import '../../widgets/custom_app_bar.dart';

// Notifications screen with swipe to delete
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,

      // App bar with back button
      appBar: CustomAppBar(
        title: 'Notifications',
        showNotification: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: isDark ? AppColors.white : AppColors.neutral,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      // Notifications list from controller
      body: Consumer<InboxController>(
        builder: (context, controller, _) => controller.buildNotificationsList(
          isDark,
        ),
      ),
    );
  }
}