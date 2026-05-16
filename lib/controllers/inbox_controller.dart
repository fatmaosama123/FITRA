// lib/controllers/inbox_controller.dart
import 'package:flutter/material.dart';
import '../models/notification_model.dart';

class InboxController extends ChangeNotifier {
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

  List<NotificationModel> get notifications =>
      List.unmodifiable(_notifications);

  List<NotificationModel> get unreadNotifications =>
      _notifications.where((n) => !n.isRead).toList();

  int get unreadCount => unreadNotifications.length;

  bool get hasUnread => unreadCount > 0;

  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1 && !_notifications[index].isRead) {
      _notifications[index].isRead = true;
      notifyListeners();
    }
  }

  void markAllAsRead() {
    for (var notification in _notifications) {
      notification.isRead = true;
    }
    notifyListeners();
  }

  void deleteNotification(String id) {
    _notifications.removeWhere((n) => n.id == id);
    notifyListeners();
  }

  void addNotification(NotificationModel notification) {
    _notifications.insert(0, notification);
    notifyListeners();
  }
}
