// lib/controllers/onboarding_controller.dart

import 'dart:async';
import 'package:flutter/material.dart';
import '../core/constants/colors.dart';
import '../core/constants/fonts.dart';
import '../routes/route_names.dart';

// Manages onboarding screen with auto-sliding image carousel
class OnboardingController extends ChangeNotifier {
  // Page controller for carousel
  final PageController pageController = PageController();
  // Current image index
  int currentPage = 0;
  // Auto-slide timer
  Timer? _timer;

  // Unsplash images for carousel
  final List<String> images = [
    'https://images.unsplash.com/photo-1509631179647-0177331693ae?w=800&q=80',
    'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=800&q=80',
    'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=800&q=80',
    'https://images.unsplash.com/photo-1469334031218-e382a71b716b?w=800&q=80',
  ];

  // Start auto-slide when controller created
  OnboardingController() {
    _startAutoPlay();
  }

  // Auto-slide every 4 seconds
  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!pageController.hasClients) return;
      final next = (currentPage + 1) % images.length;
      pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    });
  }

  // Update current page on manual swipe or auto-slide
  void onPageChanged(int index) {
    currentPage = index;
    notifyListeners(); // This triggers rebuild for dots
  }

  // Clean up timer and controller
  @override
  void dispose() {
    _timer?.cancel();
    pageController.dispose();
    super.dispose();
  }

  // ─── UI BUILDERS ───

  // Build image carousel with auto-slide
  Widget buildImageCarousel(bool isDark) => PageView.builder(
    controller: pageController,
    onPageChanged: onPageChanged,
    itemCount: images.length,
    itemBuilder: (context, index) => Stack(
      fit: StackFit.expand,
      children: [
        // Background image
        Image.network(
          images[index],
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              color: isDark ? Colors.grey[900] : Colors.grey[300],
              child: const Center(child: CircularProgressIndicator()),
            );
          },
          errorBuilder: (_, __, ___) => Container(
            color: isDark ? Colors.grey[900] : Colors.grey[300],
            child: const Icon(Icons.image_not_supported, size: 50),
          ),
        ),
        // Dark overlay for text readability
        Container(
          color: isDark
              ? Colors.black.withValues(alpha: 0.3)
              : Colors.black.withValues(alpha: 0.1),
        ),
      ],
    ),
  );

  // Build bottom gradient overlay
  Widget buildGradientOverlay(bool isDark) => Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: isDark
            ? [
                Colors.transparent,
                Colors.transparent,
                Colors.black.withValues(alpha: 0.6),
                Colors.black.withValues(alpha: 0.85),
                Colors.black.withValues(alpha: 0.95),
              ]
            : [
                Colors.transparent,
                Colors.transparent,
                Colors.white.withValues(alpha: 0.4),
                Colors.white.withValues(alpha: 0.85),
                Colors.white.withValues(alpha: 0.95),
              ],
        stops: const [0.0, 0.5, 0.75, 0.9, 1.0],
      ),
    ),
  );

  // Build page indicators - MUST use currentPage from controller
  Widget buildIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(images.length, (index) {
        // Check if this dot is active
        final isActive = currentPage == index;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 28 : 10,
          height: 10,
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.primary
                : Colors.white.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(5),
          ),
        );
      }),
    );
  }

  // Build section label
  Widget buildLabel() => _text(
    'CURATED FASHION',
    AppFonts.label,
    10,
    AppColors.primary,
    letterSpacing: 3,
  );

  // Build main headline
  Widget buildHeadline(bool isDark) => _text(
    'Discover Your\nStyle',
    AppFonts.headline,
    32,
    isDark ? AppColors.white : AppColors.neutral,
    bold: true,
    height: 1.1,
  );

  // Build description text
  Widget buildDescription(bool isDark) => _text(
    'Explore a handpicked collection of\nhigh-end streetwear designed for the\nmodern curator.',
    AppFonts.body,
    12,
    isDark ? AppColors.white.withValues(alpha: 0.8) : AppColors.textSecondary,
    height: 1.5,
  );

  // Build get started button
  Widget buildGetStartedButton(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 52,
    child: GestureDetector(
      onTap: () => Navigator.pushNamed(context, RouteNames.signup),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFF9A9E),
              Color(0xFFFF8A8A),
              Color(0xFFFF6B6B),
              Color(0xFFFF8A8A),
              Color(0xFFFF9A9E),
            ],
            stops: [0.0, 0.25, 0.5, 0.75, 1.0],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.4),
              blurRadius: 20,
              spreadRadius: 2,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _text(
                'Get Started',
                AppFonts.label,
                14,
                AppColors.white,
                bold: true,
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward, size: 18, color: AppColors.white),
            ],
          ),
        ),
      ),
    ),
  );

  // Build sign in link
  Widget buildSignInLink(BuildContext context, bool isDark) => Center(
    child: GestureDetector(
      onTap: () => Navigator.pushNamed(context, RouteNames.login),
      child: RichText(
        text: TextSpan(
          text: 'Already have an account? ',
          style: _textStyle(
            AppFonts.body,
            12,
            isDark
                ? AppColors.white.withValues(alpha: 0.7)
                : AppColors.textSecondary,
          ),
          children: [
            TextSpan(
              text: 'Sign In',
              style: _textStyle(
                AppFonts.body,
                12,
                isDark ? AppColors.white : AppColors.neutral,
                bold: true,
              )..copyWith(decoration: TextDecoration.underline),
            ),
          ],
        ),
      ),
    ),
  );

  // ─── PRIVATE HELPERS ───

  Widget _text(
    String text,
    String font,
    double size,
    Color color, {
    bool bold = false,
    double height = 1.0,
    double letterSpacing = 0,
  }) => Text(
    text,
    style: _textStyle(
      font,
      size,
      color,
      bold: bold,
      height: height,
      letterSpacing: letterSpacing,
    ),
  );

  TextStyle _textStyle(
    String font,
    double size,
    Color color, {
    bool bold = false,
    double height = 1.0,
    double letterSpacing = 0,
  }) => TextStyle(
    fontFamily: font,
    fontSize: size,
    fontWeight: bold ? FontWeight.bold : FontWeight.normal,
    color: color,
    height: height,
    letterSpacing: letterSpacing,
  );
}
