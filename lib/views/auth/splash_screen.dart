// lib/views/splash/splash_screen.dart

import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/fonts.dart';
import '../../routes/route_names.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, RouteNames.onboarding);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark
        ? AppColors.backgroundDark
        : AppColors.backgroundLight;

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          // الخلفية المموجة
          Container(
            color: isDark ? AppColors.neutral : AppColors.secondary,
            child: CustomPaint(
              size: Size.infinite,
              painter: WavePainter(isDark: isDark),
            ),
          ),

          // المحتوى
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const Spacer(flex: 2),

                  // ← جديد: Logo Image في الـ Splash (أكبر)
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimation.value,
                        child: Transform.translate(
                          offset: Offset(0, _slideAnimation.value),
                          child: Transform.scale(
                            scale: _scaleAnimation.value,
                            child: _buildLogo(isDark),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // THE TACTILE CURATOR
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimation.value,
                        child: Text(
                          'THE TACTILE CURATOR',
                          style: TextStyle(
                            fontFamily: AppFonts.label,
                            fontSize: 10,
                            letterSpacing: 3,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      );
                    },
                  ),

                  const Spacer(flex: 2),

                  // مؤشر الصفحات
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildDot(true, isDark),
                      const SizedBox(width: 6),
                      _buildDot(false, isDark),
                      const SizedBox(width: 6),
                      _buildDot(false, isDark),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // الفوتر
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'AUTUMN / WINTER\n24',
                        style: TextStyle(
                          fontFamily: AppFonts.label,
                          fontSize: 8,
                          letterSpacing: 2,
                          color: AppColors.textSecondary.withValues(alpha: 0.6),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            'PRIVACY',
                            style: TextStyle(
                              fontFamily: AppFonts.label,
                              fontSize: 8,
                              letterSpacing: 2,
                              color: AppColors.textSecondary.withValues(
                                alpha: 0.6,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'TERMS',
                            style: TextStyle(
                              fontFamily: AppFonts.label,
                              fontSize: 8,
                              letterSpacing: 2,
                              color: AppColors.textSecondary.withValues(
                                alpha: 0.6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // زر السهم
                  Container(
                    width: 48,
                    height: 3,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ← جديد: Logo Widget في الـ Splash (أكبر شوية)
  Widget _buildLogo(bool isDark) {
    final logoPath = isDark
        ? 'assets/images/logo/logo_dark.png'
        : 'assets/images/logo/logo_light.png';

    return Image.asset(
      logoPath,
      width: 200, // ← كبرت من 140 لـ 200
      height: 200, // ← كبرت من 140 لـ 200
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Text(
          'FITRA',
          style: TextStyle(
            fontFamily: AppFonts.headline,
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.white : AppColors.neutral,
            letterSpacing: 3,
          ),
        );
      },
    );
  }

  Widget _buildDot(bool isActive, bool isDark) {
    return Container(
      width: isActive ? 20 : 6,
      height: 6,
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.primary
            : isDark
            ? AppColors.white.withValues(alpha: 0.2)
            : AppColors.neutral.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

// WavePainter
class WavePainter extends CustomPainter {
  final bool isDark;

  WavePainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isDark
          ? AppColors.neutralLight.withValues(alpha: 0.3)
          : AppColors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    final path = Path();

    // موجة علوية
    path.moveTo(0, size.height * 0.15);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.1,
      size.width * 0.5,
      size.height * 0.15,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.2,
      size.width,
      size.height * 0.12,
    );
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();

    canvas.drawPath(path, paint);

    // موجة سفلية
    final path2 = Path();
    path2.moveTo(0, size.height * 0.88);
    path2.quadraticBezierTo(
      size.width * 0.3,
      size.height * 0.92,
      size.width * 0.6,
      size.height * 0.85,
    );
    path2.quadraticBezierTo(
      size.width * 0.85,
      size.height * 0.8,
      size.width,
      size.height * 0.88,
    );
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();

    canvas.drawPath(path2, paint);

    // موجة جانبية
    final paint3 = Paint()
      ..color = isDark
          ? AppColors.primary.withValues(alpha: 0.1)
          : AppColors.primary.withValues(alpha: 0.05)
      ..style = PaintingStyle.fill;

    final path3 = Path();
    path3.moveTo(size.width * 0.8, 0);
    path3.quadraticBezierTo(
      size.width * 0.9,
      size.height * 0.3,
      size.width * 0.85,
      size.height * 0.6,
    );
    path3.quadraticBezierTo(
      size.width * 0.8,
      size.height * 0.9,
      size.width,
      size.height,
    );
    path3.lineTo(size.width, 0);
    path3.close();

    canvas.drawPath(path3, paint3);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
