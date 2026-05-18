// lib/views/auth/signup_screen.dart

// Flutter material package
import 'package:flutter/material.dart';
// Provider for accessing controllers
import 'package:provider/provider.dart';
// App colors
import '../../core/constants/colors.dart';
// App fonts
import '../../core/constants/fonts.dart';
// Auth controller
import '../../controllers/auth_controller.dart';
// Profile controller
import '../../controllers/profile_controller.dart';
// Route names
import '../../routes/route_names.dart';

// Sign up screen
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Name input controller
  final _nameController = TextEditingController();
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
  // Is name valid flag
  bool _isNameValid = false;
  // Password strength data
  Map<String, dynamic> _passwordStrength = {
    'strength': 0,
    'level': 'WEAK',
    'hasMinLength': false,
    'hasNumbers': false,
    'hasLetters': false,
    'hasSpecialChars': false,
  };

  @override
  void initState() {
    super.initState();
    // Listen to name changes
    _nameController.addListener(_checkName);
    // Listen to password changes
    _passwordController.addListener(_checkPassword);
  }

  // Validate name input
  void _checkName() => setState(
    () => _isNameValid = AuthController.isNameValid(_nameController.text),
  );

  // Check password strength
  void _checkPassword() => setState(() {
    _hasPasswordText = _passwordController.text.isNotEmpty;
    _passwordStrength = AuthController.checkPasswordStrength(
      _passwordController.text,
    );
  });

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Sign up handler
  void _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final userData = {
      'name': _nameController.text.trim(),
      'email': _emailController.text.trim(),
      'password': _passwordController.text,
    };

    final success = await _authController.signUp(userData);

    setState(() => _isLoading = false);

    if (success && mounted) {
      // Load user profile after signup
      final profileController = Provider.of<ProfileController>(
        context,
        listen: false,
      );
      profileController.loadUser(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        name: _nameController.text.trim(),
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
                // Welcome subtitle
                Text(
                  'Join our curated community of\nmovement and mindful style.',
                  textAlign: TextAlign.center,
                  style: _subHeaderStyle(isDark),
                ),
                const SizedBox(height: 24),
                // Sign up form card
                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxWidth: 320),
                  padding: const EdgeInsets.all(20),
                  decoration: _cardDecoration(isDark),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name label
                      AuthController.buildLabel('FULL NAME', isDark),
                      const SizedBox(height: 6),
                      // Name input field
                      AuthController.buildTextField(
                        controller: _nameController,
                        hint: 'Fatma Osama',
                        validator: (v) =>
                            AuthController.validateRequired(v, 'Full name'),
                        // Show check icon when name is valid
                        suffixIcon: _isNameValid
                            ? const Icon(
                                Icons.check_circle,
                                color: Color(0xFF1B5E20),
                                size: 20,
                              )
                            : null,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 16),
                      // Email label
                      AuthController.buildLabel('EMAIL ADDRESS', isDark),
                      const SizedBox(height: 6),
                      // Email input field
                      AuthController.buildTextField(
                        controller: _emailController,
                        hint: 'fatma.osama@email.com',
                        validator: AuthController.validateEmail,
                        keyboardType: TextInputType.emailAddress,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 16),
                      // Password label
                      AuthController.buildLabel('PASSWORD', isDark),
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
                      const SizedBox(height: 10),
                      // Password strength indicator
                      if (_hasPasswordText)
                        AuthController.buildStrengthIndicator(
                          _passwordStrength,
                          isDark,
                        ),
                      const SizedBox(height: 20),
                      // Create account button
                      AuthController.buildGradientButton(
                        text: 'Create Account',
                        isLoading: _isLoading,
                        onTap: _signUp,
                        suffixIcon: const Icon(
                          Icons.arrow_forward,
                          color: AppColors.white,
                          size: 18,
                        ),
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
                // Sign in link
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, RouteNames.login),
                  child: RichText(
                    text: TextSpan(
                      text: 'Already have an account? ',
                      style: TextStyle(
                        fontFamily: 'BeVietnamPro',
                        fontSize: 12,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.7)
                            : AppColors.textSecondary,
                      ),
                      children: [
                        TextSpan(
                          text: 'Sign In',
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

  // Subtitle text style
  TextStyle _subHeaderStyle(bool isDark) => TextStyle(
    fontFamily: 'BeVietnamPro',
    fontSize: 12,
    height: 1.4,
    color: isDark
        ? Colors.white.withValues(alpha: 0.7)
        : AppColors.textSecondary,
  );

  // Card decoration style
  BoxDecoration _cardDecoration(bool isDark) => BoxDecoration(
    color: isDark
        ? Colors.white.withValues(alpha: 0.06)
        : AppColors.white,
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