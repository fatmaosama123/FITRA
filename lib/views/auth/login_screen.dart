// lib/views/auth/login_screen.dart

// Flutter material package
import 'package:flutter/material.dart';
// Provider for reading controllers
import 'package:provider/provider.dart';
// App colors
import '../../core/constants/colors.dart';
// Auth controller
import '../../controllers/auth_controller.dart';
// Profile controller
import '../../controllers/profile_controller.dart';
// Route names
import '../../routes/route_names.dart';

// Login screen
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Email input controller
  final _emailController = TextEditingController();
  // Password input controller
  final _passwordController = TextEditingController();

  // Form validation key
  final _formKey = GlobalKey<FormState>();
  // Auth controller instance
  final _authController = AuthController();

  // Password visibility state
  bool _isPasswordVisible = false;
  // Loading state flag
  bool _isLoading = false;
  // Has password text flag
  bool _hasPasswordText = false;

  @override
  void initState() {
    super.initState();
    // Listen to password changes
    _passwordController.addListener(
      () => setState(() {
        _hasPasswordText = _passwordController.text.isNotEmpty;
      }),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Sign in handler
  void _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final success = await _authController.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    setState(() => _isLoading = false);

    if (success && mounted) {
      // Load user profile after login
      final profileController = context.read<ProfileController>();
      profileController.loadUser(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        name: _emailController.text.trim().split('@')[0],
        email: _emailController.text.trim(),
        avatarUrl:
            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400&h=400&fit=crop&crop=face',
      );

      // Navigate to main layout
      Navigator.pushReplacementNamed(context, RouteNames.mainLayout);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                // App logo
                _buildLogo(isDark),
                const SizedBox(height: 16),
                // Welcome title
                Text('Welcome back', style: _welcomeStyle(isDark)),
                const SizedBox(height: 4),
                // Welcome subtitle
                Text(
                  'Curated fashion awaits your return.',
                  textAlign: TextAlign.center,
                  style: _subHeaderStyle(isDark),
                ),
                const SizedBox(height: 24),
                // Login form card
                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxWidth: 320),
                  padding: const EdgeInsets.all(20),
                  decoration: _cardDecoration(isDark),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Email label
                      AuthController.buildLabel('EMAIL ADDRESS', isDark),
                      const SizedBox(height: 6),
                      // Email input field
                      AuthController.buildTextField(
                        controller: _emailController,
                        hint: 'name@example.com',
                        validator: AuthController.validateEmail,
                        keyboardType: TextInputType.emailAddress,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 16),
                      // Password label and forgot link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AuthController.buildLabel('PASSWORD', isDark),
                          // Forgot password link
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(
                              context,
                              RouteNames.forgotPassword,
                            ),
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                fontFamily: 'BeVietnamPro',
                                fontSize: 10,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // Password input field
                      AuthController.buildPasswordField(
                        controller: _passwordController,
                        isVisible: _isPasswordVisible,
                        hasText: _hasPasswordText,
                        onToggleVisibility: () => setState(
                          () => _isPasswordVisible = !_isPasswordVisible,
                        ),
                        isDark: isDark,
                      ),
                      const SizedBox(height: 20),
                      // Sign in button
                      AuthController.buildGradientButton(
                        text: 'Sign In',
                        isLoading: _isLoading,
                        onTap: _signIn,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // OR divider
                AuthController.buildOrDivider(isDark),
                const SizedBox(height: 16),
                // Social login buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AuthController.buildSocialButton(
                      icon: Icons.g_mobiledata,
                      label: 'Google',
                      color: Colors.blue[600]!,
                      isDark: false,
                    ),
                    const SizedBox(width: 12),
                    AuthController.buildSocialButton(
                      icon: Icons.apple,
                      label: 'Apple',
                      color: AppColors.white,
                      isDark: true,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Sign up link
                GestureDetector(
                  onTap: () => Navigator.pushReplacementNamed(
                    context,
                    RouteNames.signup,
                  ),
                  child: RichText(
                    text: TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(
                        fontFamily: 'BeVietnamPro',
                        fontSize: 12,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.7)
                            : AppColors.textSecondary,
                      ),
                      children: [
                        TextSpan(
                          text: 'Create Account',
                          style: TextStyle(
                            fontFamily: 'BeVietnamPro',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Build app logo with fallback text
  Widget _buildLogo(bool isDark) {
    final logoPath = isDark
        ? 'assets/images/logo/logo_dark.png'
        : 'assets/images/logo/logo_light.png';

    return Center(
      child: Image.asset(
        logoPath,
        width: 120,
        height: 120,
        fit: BoxFit.contain,
        // Fallback text if image fails
        errorBuilder: (context, error, stackTrace) {
          return Text(
            'FITRA',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.white : AppColors.neutral,
              letterSpacing: 3,
            ),
          );
        },
      ),
    );
  }

  // Welcome title style
  TextStyle _welcomeStyle(bool isDark) => TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: isDark ? AppColors.white : AppColors.neutral,
  );

  // Subtitle text style
  TextStyle _subHeaderStyle(bool isDark) => TextStyle(
    fontFamily: 'BeVietnamPro',
    fontSize: 12,
    color: isDark
        ? Colors.white.withValues(alpha: 0.7)
        : AppColors.textSecondary,
  );

  // Card decoration style
  BoxDecoration _cardDecoration(bool isDark) => BoxDecoration(
    color: isDark ? Colors.white.withValues(alpha: 0.06) : AppColors.white,
    borderRadius: BorderRadius.circular(20),
    border: Border.all(
      color: isDark
          ? Colors.white.withValues(alpha: 0.05)
          : AppColors.neutral.withValues(alpha: 0.08),
      width: 0.5,
    ),
    boxShadow: isDark
        ? null
        : [
            BoxShadow(
              color: AppColors.neutral.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
  );
}