// lib/widgets/custom_app_bar.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/constants/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showMenu;
  final bool showNotification;
  final int notificationCount;
  final VoidCallback? onMenuTap;
  final VoidCallback? onNotificationTap;
  final double scrollOffset;

  const CustomAppBar({
    super.key,
    this.title,
    this.actions,
    this.leading,
    this.showMenu = false,
    this.showNotification = true,
    this.notificationCount = 0,
    this.onMenuTap,
    this.onNotificationTap,
    this.scrollOffset = 0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bool hasShadow = scrollOffset > 10;

    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(24),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.3)
                    : Colors.white.withValues(alpha: 0.7),
                border: Border(
                  bottom: BorderSide(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : Colors.black.withValues(alpha: 0.05),
                    width: 0.5,
                  ),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Container(
                  height: kToolbarHeight + 8,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 6,
                  ),
                  child: Row(
                    children: [
                      _buildLeading(isDark, context),
                      const SizedBox(width: 16),

                      Expanded(
                        child: title != null
                            ? _buildTitle(isDark)
                            : _buildLogo(isDark),
                      ),

                      const SizedBox(width: 16),

                      _buildActions(isDark, context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        if (hasShadow)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Container(
                height: 24,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withValues(alpha: 0.15)
                          : Colors.black.withValues(alpha: 0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                      spreadRadius: -2,
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLeading(bool isDark, BuildContext context) {
    if (showMenu) {
      return GestureDetector(
        onTap:
            onMenuTap ??
            () => Scaffold.of(context).openDrawer(), // ✅ يفتح الـ Drawer
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          child: Icon(
            Icons.menu_rounded,
            color: isDark
                ? Colors.white.withValues(alpha: 0.8)
                : Colors.black87,
            size: 24,
          ),
        ),
      );
    }

    if (leading != null) {
      return Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        child: leading,
      );
    }

    return const SizedBox(width: 40);
  }

  Widget _buildLogo(bool isDark) {
    final logoPath = isDark
        ? 'assets/images/logo_white.png'
        : 'assets/images/logo_dark.png';

    return Center(
      child: Transform.scale(
        scale: 2.5,
        child: Image.asset(
          logoPath,
          height: 28,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Text(
              'FITRA',
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                letterSpacing: 4,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTitle(bool isDark) {
    return Center(
      child: Text(
        title!,
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildActions(bool isDark, BuildContext context) {
    final List<Widget> actionWidgets = [];

    if (actions != null) {
      actionWidgets.addAll(actions!);
    } else if (showNotification) {
      actionWidgets.add(_buildNotificationButton(isDark, context));
    }

    if (actionWidgets.isEmpty) {
      return const SizedBox(width: 40);
    }

    return Row(mainAxisSize: MainAxisSize.min, children: actionWidgets);
  }

  Widget _buildNotificationButton(bool isDark, BuildContext context) {
    return GestureDetector(
      onTap:
          onNotificationTap ??
          () {
            Navigator.pushNamed(context, '/notifications');
          },
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.notifications_outlined,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.8)
                  : Colors.black87,
              size: 24,
            ),
            if (notificationCount > 0)
              Positioned(
                top: 6,
                right: 4,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B6B),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark
                          ? Colors.black.withValues(alpha: 0.3)
                          : Colors.white,
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      notificationCount > 9 ? '9+' : '$notificationCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 16);
}
