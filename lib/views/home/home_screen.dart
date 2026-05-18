// lib/views/home/home_screen.dart

import 'package:flutter/material.dart';
import '../../controllers/home_controller.dart';
import '../../widgets/ad_banner_carousel.dart';
import '../../widgets/promo_banner.dart';

// Home screen with search, categories, and products
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Home controller instance
  final controller = HomeController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) => Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Search bar from controller
              controller.buildSearchBar(isDark, controller.updateSearch),
              const SizedBox(height: 20),
              // Ad banner carousel (auto-scrolls every 5 seconds)
              const AdBannerCarousel(),
              const SizedBox(height: 28),
              // Categories horizontal list from controller
              controller.buildCategories(isDark, context),
              const SizedBox(height: 28),
              // Trending products section from controller
              controller.buildTrendingSection(isDark, context),
              const SizedBox(height: 32),
              // New arrivals section from controller
              controller.buildNewArrivalsSection(isDark, context),
              const SizedBox(height: 32),
              // Promo banner
              const PromoBanner(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}