// lib/views/category/category_details_screen.dart

import 'package:flutter/material.dart';
import '../../controllers/category_details_controller.dart';
import '../../widgets/app_scaffold.dart';

class CategoryDetailsScreen extends StatefulWidget {
  const CategoryDetailsScreen({super.key});

  @override
  State<CategoryDetailsScreen> createState() => _CategoryDetailsScreenState();
}

class _CategoryDetailsScreenState extends State<CategoryDetailsScreen> {
  final controller = CategoryDetailsController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final categoryName =
        ModalRoute.of(context)?.settings.arguments as String? ?? 'Category';
    controller.init(categoryName);
  }

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
      builder: (context, _) => AppScaffold(
        title: controller.categoryName,
        showMenu: true,
        showNotification: true,
        currentNavIndex: 1, // SHOP tab
        body: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header + Image Carousel + Filter/Sort (from controller)
                controller.buildHeader(isDark),
                // Products list (from controller)
                controller.buildProductsList(isDark),
                const SizedBox(height: 32),
                // Explore more button (from controller)
                controller.buildExploreButton(isDark),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}