// lib/controllers/inbox_controller.dart

import 'package:flutter/material.dart';
import '../models/notification_model.dart';
import '../core/constants/colors.dart';
import '../core/constants/fonts.dart';

// Manages inbox notifications state and UI builders
class InboxController extends ChangeNotifier {

  // ─── Notifications List ───

  // Mock notifications data
  final List<NotificationModel> _notifications = [
    NotificationModel(
      id: '1',
      title: 'Order Shipped!',
      body: 'Your order #12345 has been shipped and will arrive in 2-3 days.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      isRead: false,
      type: NotificationType.order,
    ),
    NotificationModel(
      id: '2',
      title: 'Summer Sale',
      body: 'Get 50% off on all summer collection items. Limited time offer!',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
      type: NotificationType.promotion,
    ),
    NotificationModel(
      id: '3',
      title: 'Welcome to FITRA',
      body: 'Thanks for joining us! Start exploring our latest collections.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
      type: NotificationType.system,
    ),
    NotificationModel(
      id: '4',
      title: 'Profile Updated',
      body: 'Your profile information has been successfully updated.',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
      type: NotificationType.system,
    ),
  ];

  // ─── Getters ───

  // Get all notifications (unmodifiable)
  List<NotificationModel> get notifications =>
      List.unmodifiable(_notifications);

  // Get unread notifications only
  List<NotificationModel> get unreadNotifications =>
      _notifications.where((n) => !n.isRead).toList();

  // Count of unread notifications
  int get unreadCount => unreadNotifications.length;

  // Check if there are unread notifications
  bool get hasUnread => unreadCount > 0;

  // ─── Methods ───

  // Mark single notification as read
  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1 && !_notifications[index].isRead) {
      _notifications[index].isRead = true;
      notifyListeners();
    }
  }

  // Mark all notifications as read
  void markAllAsRead() {
    for (var notification in _notifications) {
      notification.isRead = true;
    }
    notifyListeners();
  }

  // Delete notification by id
  void deleteNotification(String id) {
    _notifications.removeWhere((n) => n.id == id);
    notifyListeners();
  }

  // Add new notification to top
  void addNotification(NotificationModel notification) {
    _notifications.insert(0, notification);
    notifyListeners();
  }

  // ─── UI BUILDERS ───

  // Build unread count header with mark all read button
  Widget buildUnreadHeader(bool isDark) {
    if (!hasUnread) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Unread count text
          _text(
            '$unreadCount unread',
            AppFonts.body,
            14,
            AppColors.textSecondary,
          ),
          // Mark all read button
          GestureDetector(
            onTap: markAllAsRead,
            child: _text(
              'Mark all as read',
              AppFonts.label,
              14,
              AppColors.primary,
              bold: true,
            ),
          ),
        ],
      ),
    );
  }

  // Build empty state when no notifications
  Widget buildEmptyState(bool isDark) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Empty icon circle
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
            // Empty title
            _text(
              'No Notifications',
              AppFonts.headline,
              22,
              isDark ? AppColors.white : AppColors.neutral,
              bold: true,
            ),
            const SizedBox(height: 8),
            // Empty description
            Text(
              'You\'re all caught up! Check back later for updates.',
              textAlign: TextAlign.center,
              style: _textStyle(AppFonts.body, 14, AppColors.textSecondary),
            ),
          ],
        ),
      );

  // Build single notification item with swipe to delete
  Widget buildNotificationItem(
    NotificationModel notification,
    bool isDark,
  ) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      // Delete on swipe
      onDismissed: (_) => deleteNotification(notification.id),
      // Red swipe background
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
        // Mark as read on tap
        onTap: () {
          if (!notification.isRead) {
            markAsRead(notification.id);
          }
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.neutral : AppColors.white,
            borderRadius: BorderRadius.circular(16),
            // Highlight unread with border
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
              // Notification icon
              _buildIcon(notification),
              const SizedBox(width: 12),
              // Notification content
              Expanded(
                child: _buildContent(notification, isDark),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build notification icon container
  Widget _buildIcon(NotificationModel notification) => Container(
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
      );

  // Build notification text content
  Widget _buildContent(NotificationModel notification, bool isDark) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row with unread dot
          Row(
            children: [
              Expanded(
                child: _text(
                  notification.title,
                  AppFonts.headline,
                  15,
                  isDark ? AppColors.white : AppColors.neutral,
                  bold: !notification.isRead,
                ),
              ),
              // Unread red dot
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
          // Body text
          Text(
            notification.body,
            style: _textStyle(AppFonts.body, 13, AppColors.textSecondary),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          // Time ago
          _text(
            notification.timeAgo,
            AppFonts.body,
            11,
            AppColors.textSecondary.withValues(alpha: 0.7),
          ),
        ],
      );

  // Build full notifications list
  Widget buildNotificationsList(bool isDark) {
    if (_notifications.isEmpty) {
      return buildEmptyState(isDark);
    }

    return Column(
      children: [
        // Unread header (if any)
        buildUnreadHeader(isDark),
        const SizedBox(height: 16),
        // List of notifications
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _notifications.length,
            itemBuilder: (context, index) => buildNotificationItem(
              _notifications[index],
              isDark,
            ),
          ),
        ),
      ],
    );
  }

  // ─── PRIVATE HELPERS ───

  // Quick text widget
  Widget _text(
    String text,
    String font,
    double size,
    Color color, {
    bool bold = false,
  }) =>
      Text(
        text,
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
}