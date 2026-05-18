// lib/views/shop/collection_details_screen.dart

import 'package:flutter/material.dart';
import '../../controllers/collection_details_controller.dart';
import '../../widgets/custom_app_bar.dart';

class CollectionDetailsScreen extends StatefulWidget {
  const CollectionDetailsScreen({super.key});

  @override
  State<CollectionDetailsScreen> createState() => _CollectionDetailsScreenState();
}

class _CollectionDetailsScreenState extends State<CollectionDetailsScreen> {
  final controller = CollectionDetailsController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final title =
        ModalRoute.of(context)?.settings.arguments as String? ?? 'Collection';
    controller.init(title);
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
      builder: (context, _) => Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: CustomAppBar(
          title: controller.categoryName,
          showMenu: false,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              controller.buildHeader(isDark),
              controller.buildProducts(isDark),
              const SizedBox(height: 32),
              // FIXED: Pass onTap callback with context
              controller.buildExploreButton(
                isDark,
                () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/main',
                  (route) => false,
                  arguments: {'tab': 1}, // Go to SHOP tab
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}