// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/cart_controller.dart';
import 'controllers/inbox_controller.dart';
import 'controllers/profile_controller.dart';
import 'controllers/theme_controller.dart'; //
import 'core/theme/light_theme.dart';
import 'core/theme/theme_dark.dart';
import 'routes/app_routes.dart';
import 'routes/route_names.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeController()), // ✅ جديد
        ChangeNotifierProvider(create: (_) => CartController()),
        ChangeNotifierProvider(create: (_) => ProfileController()),
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
    // ✅ بيشوف الـ ThemeMode من الـ ThemeController
    final themeController = context.watch<ThemeController>();

    return MaterialApp(
      title: 'FITRA',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      // ✅ بيستخدم الـ themeMode من الـ Controller بدل الـ system
      themeMode: themeController.themeMode,

      initialRoute: RouteNames.splash,
      routes: AppRoutes.routes,

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
