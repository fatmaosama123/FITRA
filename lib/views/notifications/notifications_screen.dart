// lib/views/notifications/notifications_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/inbox_controller.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/fonts.dart';
import '../../models/notification_model.dart';
import '../../widgets/custom_app_bar.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,

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

      body: Consumer<InboxController>(
        builder: (context, controller, child) {
          final notifications = controller.notifications;

          if (notifications.isEmpty) {
            return _buildEmptyState(isDark);
          }

          return Column(
            children: [
              if (controller.hasUnread)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${controller.unreadCount} unread',
                        style: TextStyle(
                          fontFamily: AppFonts.body,
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => controller.markAllAsRead(),
                        child: Text(
                          'Mark all as read',
                          style: TextStyle(
                            fontFamily: AppFonts.label,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 16),

              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    return _buildNotificationItem(
                      context,
                      controller,
                      notifications[index],
                      isDark,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
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
              Icons.notifications_off_outlined,
              size: 50,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Notifications',
            style: TextStyle(
              fontFamily: AppFonts.headline,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.white : AppColors.neutral,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You\'re all caught up! Check back later for updates.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppFonts.body,
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(
    BuildContext context,
    InboxController controller,
    NotificationModel notification,
    bool isDark,
  ) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => controller.deleteNotification(notification.id),
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_outline, color: Colors.red),
      ),
      child: GestureDetector(
        onTap: () {
          if (!notification.isRead) {
            controller.markAsRead(notification.id);
          }
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.neutral : AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: !notification.isRead
                ? Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    width: 1,
                  )
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: notification.iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  notification.icon,
                  color: notification.iconColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontFamily: AppFonts.headline,
                              fontSize: 15,
                              fontWeight: !notification.isRead
                                  ? FontWeight.bold
                                  : FontWeight.w600,
                              color: isDark
                                  ? AppColors.white
                                  : AppColors.neutral,
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFF6B6B),
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.body,
                      style: TextStyle(
                        fontFamily: AppFonts.body,
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      notification.timeAgo,
                      style: TextStyle(
                        fontFamily: AppFonts.body,
                        fontSize: 11,
                        color: AppColors.textSecondary.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
