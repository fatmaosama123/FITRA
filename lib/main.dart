// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/cart_controller.dart';
import 'controllers/inbox_controller.dart';
import 'controllers/profile_controller.dart';
import 'controllers/theme_controller.dart'; // Manages light/dark theme switching
import 'core/theme/light_theme.dart';
import 'core/theme/theme_dark.dart';
import 'routes/app_routes.dart';
import 'routes/route_names.dart';

// App entry point
void main() {
  runApp(
    // Provide multiple controllers to the whole app
    MultiProvider(
      providers: [
        // NEW: Theme controller for dark/light mode
        ChangeNotifierProvider(create: (_) => ThemeController()),
        // Cart controller for shopping cart state
        ChangeNotifierProvider(create: (_) => CartController()),
        // Profile controller for user data
        ChangeNotifierProvider(create: (_) => ProfileController()),
        // Inbox controller for notifications/messages
        ChangeNotifierProvider(create: (_) => InboxController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Watch theme mode from ThemeController
    final themeController = context.watch<ThemeController>();

    return MaterialApp(
      title: 'FITRA',
      // Hide the debug banner in top-right corner
      debugShowCheckedModeBanner: false,
      // Light theme colors
      theme: lightTheme,
      // Dark theme colors
      darkTheme: darkTheme,
      // Use themeMode from controller instead of system default
      themeMode: themeController.themeMode,

      // First screen when app opens
      initialRoute: RouteNames.splash,
      // All app routes
      routes: AppRoutes.routes,

      // Fallback screen for unknown routes (404 page)
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(
              child: Text(
                'Page not found: ${settings.name}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        );
      },
    );
  }
}