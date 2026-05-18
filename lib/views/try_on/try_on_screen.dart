// lib/views/try_on/try_on_screen.dart

import 'package:flutter/material.dart';
import '../../controllers/try_on_controller.dart';

// Virtual try-on screen with photo upload and product preview
class TryOnScreen extends StatefulWidget {
  const TryOnScreen({super.key});

  @override
  State<TryOnScreen> createState() => _TryOnScreenState();
}

class _TryOnScreenState extends State<TryOnScreen> {
  // Try-on controller instance
  final controller = TryOnController();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) => Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              // Page title
              controller.buildTitle(isDark),
              const SizedBox(height: 12),
              // Description
              controller.buildDescription(),
              const SizedBox(height: 24),
              // Upload photo card
              controller.buildUploadCard(isDark),
              const SizedBox(height: 24),
              // Pro tips
              controller.buildProTips(isDark),
              const SizedBox(height: 24),
              // Live preview
              controller.buildLivePreview(isDark),
              const SizedBox(height: 20),
              // Try it on button
              controller.buildTryItOnButton(isDark),
              const SizedBox(height: 32),
              // More options header
              controller.buildMoreOptionsHeader(isDark),
              const SizedBox(height: 16),
              // Recommended products grid
              controller.buildRecommendedGrid(isDark),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}