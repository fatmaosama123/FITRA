// lib/models/notification_model.dart
import 'package:flutter/material.dart';
import '../core/constants/colors.dart'; // ✅ جديد

enum NotificationType { order, promotion, system }

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
  bool isRead;
  final NotificationType type;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    this.isRead = false,
    this.type = NotificationType.system,
  });

  String get timeAgo {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
  }

  IconData get icon {
    switch (type) {
      case NotificationType.order:
        return Icons.local_shipping_outlined;
      case NotificationType.promotion:
        return Icons.local_offer_outlined;
      case NotificationType.system:
        return Icons.notifications_outlined;
    }
  }

  Color get iconColor {
    switch (type) {
      case NotificationType.order:
        return const Color(0xFF4A90D9);
      case NotificationType.promotion:
        return AppColors.primary; // ✅ دلوقتي شغال
      case NotificationType.system:
        return Colors.grey;
    }
  }
}
