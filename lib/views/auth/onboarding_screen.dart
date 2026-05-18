// lib/views/onboarding/onboarding_screen.dart

import 'package:flutter/material.dart';
import '../../controllers/onboarding_controller.dart';

// Onboarding screen with auto-sliding image carousel
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // Onboarding controller with carousel
  final controller = OnboardingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Use AnimatedBuilder to rebuild when currentPage changes
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Scaffold(
          body: Stack(
            fit: StackFit.expand,
            children: [
              // Image carousel from controller
              controller.buildImageCarousel(isDark),

              // Bottom gradient overlay from controller
              controller.buildGradientOverlay(isDark),

              // Content overlay
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      const Spacer(),
                      // Page indicators - rebuild when currentPage changes
                      Center(child: controller.buildIndicators()),
                      const SizedBox(height: 24),
                      // Section label
                      controller.buildLabel(),
                      const SizedBox(height: 8),
                      // Main headline
                      controller.buildHeadline(isDark),
                      const SizedBox(height: 12),
                      // Description
                      controller.buildDescription(isDark),
                      const SizedBox(height: 24),
                      // Get Started button
                      controller.buildGetStartedButton(context),
                      const SizedBox(height: 16),
                      // Sign in link
                      controller.buildSignInLink(context, isDark),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}