// lib/views/auth/forgot_password_screen.dart

import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../controllers/auth_controller.dart';
import '../../routes/route_names.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _authController = AuthController();

  bool _isLoading = false;

  void _sendResetEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final success = await _authController.sendPasswordResetEmail(
      _emailController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (success && mounted) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? AppColors.white : AppColors.neutral,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
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
                const SizedBox(height: 24),
                Text('Forgot Password?', style: _titleStyle(isDark)),
                const SizedBox(height: 8),
                Text(
                  'Enter your email address and we\'ll send you a link to reset your password.',
                  textAlign: TextAlign.center,
                  style: _subHeaderStyle(isDark),
                ),
                const SizedBox(height: 32),
                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxWidth: 320),
                  padding: const EdgeInsets.all(20),
                  decoration: _cardDecoration(isDark),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AuthController.buildLabel('EMAIL ADDRESS', isDark),
                      const SizedBox(height: 6),
                      AuthController.buildTextField(
                        controller: _emailController,
                        hint: 'name@example.com',
                        validator: AuthController.validateEmail,
                        keyboardType: TextInputType.emailAddress,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 20),
                      AuthController.buildGradientButton(
                        text: 'Send Reset Link',
                        isLoading: _isLoading,
                        onTap: _sendResetEmail,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Text(
                    'Back to Login',
                    style: TextStyle(
                      fontFamily: 'BeVietnamPro',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
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

  TextStyle _titleStyle(bool isDark) => TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: isDark ? AppColors.white : AppColors.neutral,
  );

  TextStyle _subHeaderStyle(bool isDark) => TextStyle(
    fontFamily: 'BeVietnamPro',
    fontSize: 12,
    height: 1.4,
    color: isDark
        ? Colors.white.withValues(alpha: 0.7)
        : AppColors.textSecondary,
  );

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
