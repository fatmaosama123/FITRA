// lib/views/auth/signup_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/fonts.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/profile_controller.dart';
import '../../routes/route_names.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _authController = AuthController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _hasPasswordText = false;
  bool _isNameValid = false;
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
    _nameController.addListener(_checkName);
    _passwordController.addListener(_checkPassword);
  }

  void _checkName() => setState(
    () => _isNameValid = AuthController.isNameValid(_nameController.text),
  );

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
                _buildLogo(isDark),
                const SizedBox(height: 16),
                Text(
                  'Join our curated community of\nmovement and mindful style.',
                  textAlign: TextAlign.center,
                  style: _subHeaderStyle(isDark),
                ),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxWidth: 320),
                  padding: const EdgeInsets.all(20),
                  decoration: _cardDecoration(isDark),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AuthController.buildLabel('FULL NAME', isDark),
                      const SizedBox(height: 6),
                      AuthController.buildTextField(
                        controller: _nameController,
                        hint: 'Fatma Osama',
                        validator: (v) =>
                            AuthController.validateRequired(v, 'Full name'),
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
                      AuthController.buildLabel('EMAIL ADDRESS', isDark),
                      const SizedBox(height: 6),
                      AuthController.buildTextField(
                        controller: _emailController,
                        hint: 'fatma.osama@email.com',
                        validator: AuthController.validateEmail,
                        keyboardType: TextInputType.emailAddress,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 16),
                      AuthController.buildLabel('PASSWORD', isDark),
                      const SizedBox(height: 6),
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
                      if (_hasPasswordText)
                        AuthController.buildStrengthIndicator(
                          _passwordStrength,
                          isDark,
                        ),
                      const SizedBox(height: 20),
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
                AuthController.buildOrDivider(isDark),
                const SizedBox(height: 16),
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

  TextStyle _subHeaderStyle(bool isDark) => TextStyle(
    fontFamily: 'BeVietnamPro',
    fontSize: 12,
    height: 1.4,
    color: isDark
        ? Colors.white.withValues(alpha: 0.7)
        : AppColors.textSecondary,
  );

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