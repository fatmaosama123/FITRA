// lib/views/onboarding/onboarding_screen.dart

import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/fonts.dart';
import '../../routes/route_names.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // الخلفية - صورة الموديل
          Image.asset(
            'assets/images/onboarding_model.png',
            fit: BoxFit.cover,
            color: isDark ? Colors.black.withValues(alpha: 0.3) : null,
            colorBlendMode: isDark ? BlendMode.darken : null,
          ),

          // طبقة تدرج خفيفة من الأسفل
          Container(
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
          ),

          // المحتوى
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // ← مفيش Logo هنا
                  const Spacer(),

                  Text(
                    'CURATED FASHION',
                    style: TextStyle(
                      fontFamily: AppFonts.label,
                      fontSize: 10,
                      letterSpacing: 3,
                      color: AppColors.primary,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Discover Your\nStyle',
                    style: TextStyle(
                      fontFamily: AppFonts.headline,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.white : AppColors.neutral,
                      height: 1.1,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    'Explore a handpicked collection of\nhigh-end streetwear designed for the\nmodern curator.',
                    style: TextStyle(
                      fontFamily: AppFonts.body,
                      fontSize: 12,
                      height: 1.5,
                      color: isDark
                          ? AppColors.white.withValues(alpha: 0.8)
                          : AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // زر Get Started
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, RouteNames.signup);
                      },
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
                              Text(
                                'Get Started',
                                style: TextStyle(
                                  fontFamily: AppFonts.label,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.white,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.arrow_forward,
                                size: 18,
                                color: AppColors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Already have an account? Sign In
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, RouteNames.login);
                      },
                      child: RichText(
                        text: TextSpan(
                          text: 'Already have an account? ',
                          style: TextStyle(
                            fontFamily: AppFonts.body,
                            fontSize: 12,
                            color: isDark
                                ? AppColors.white.withValues(alpha: 0.7)
                                : AppColors.textSecondary,
                          ),
                          children: [
                            TextSpan(
                              text: 'Sign In',
                              style: TextStyle(
                                fontFamily: AppFonts.body,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? AppColors.white
                                    : AppColors.neutral,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
