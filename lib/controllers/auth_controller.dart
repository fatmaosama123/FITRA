// lib/controllers/auth_controller.dart

import 'package:flutter/material.dart';
import '../core/constants/colors.dart';
import '../core/constants/fonts.dart';

// Controller for authentication logic and reusable auth widgets
class AuthController extends ChangeNotifier {

  // Check if name length is valid
  static bool isNameValid(String name) => name.trim().length >= 3;

  // Check if email format is correct
  static bool isEmailValid(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  // Validate email field
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    if (!isEmailValid(value)) return 'Please enter a valid email';
    return null;
  }

  // Validate required fields
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) return '$fieldName is required';
    return null;
  }

  // Check password strength
  static Map<String, dynamic> checkPasswordStrength(String password) {
    bool hasMinLength = password.length >= 8;
    bool hasNumbers = password.contains(RegExp(r'[0-9]'));
    bool hasLetters = password.contains(RegExp(r'[a-zA-Z]'));
    bool hasSpecialChars = password.contains(RegExp(r'[@$!%*?&_]'));

    int strength = 0;

    // Increase strength score based on conditions
    if (hasMinLength) strength++;
    if (hasNumbers) strength++;
    if (hasLetters) strength++;
    if (hasSpecialChars) strength++;

    String level;

    // Set password level
    if (strength == 4)
      level = 'STRONG';
    else if (strength >= 2)
      level = 'MEDIUM';
    else
      level = 'WEAK';

    // Return password details
    return {
      'strength': strength,
      'level': level,
      'hasMinLength': hasMinLength,
      'hasNumbers': hasNumbers,
      'hasLetters': hasLetters,
      'hasSpecialChars': hasSpecialChars,
    };
  }

  // Simulate sign up request
  Future<bool> signUp(Map<String, dynamic> userData) async {
    await Future.delayed(const Duration(seconds: 2));
    return true;
  }

  // Simulate login request
  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));

    if (!isEmailValid(email)) return false;
    if (password.length < 6) return false;

    return true;
  }

  // Simulate sending reset password email
  Future<bool> sendPasswordResetEmail(String email) async {
    await Future.delayed(const Duration(seconds: 2));

    if (!isEmailValid(email)) return false;

    return true;
  }

  // ==================== UI WIDGETS ====================

  // Build label text
  static Widget buildLabel(String text, bool isDark) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'BeVietnamPro',
        fontSize: 10,
        letterSpacing: 1.2,
        fontWeight: FontWeight.w600,
        color: isDark ? Colors.white70 : const Color(0xFF1A1A1A),
      ),
    );
  }

  // Build reusable text field
  static Widget buildTextField({
    required TextEditingController controller,
    required String hint,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    Widget? suffixIcon,
    required bool isDark,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,

      // Text style
      style: TextStyle(
        fontFamily: 'BeVietnamPro',
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: isDark ? Colors.white : const Color(0xFF1A1A1A),
      ),

      // Field decoration
      decoration: InputDecoration(
        hintText: hint,

        // Hint style
        hintStyle: TextStyle(
          fontFamily: 'BeVietnamPro',
          fontSize: 14,
          color: isDark
              ? Colors.white.withValues(alpha: 0.3)
              : AppColors.textSecondary.withValues(alpha: 0.4),
        ),

        filled: true,

        // Background color
        fillColor: isDark
            ? Colors.white.withValues(alpha: 0.08)
            : AppColors.secondary.withValues(alpha: 0.5),

        // Default border
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),

        // Enabled border
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),

        // Focused border
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 1.5,
          ),
        ),

        // Error border
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),

        // Focused error border
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),

        // Inner padding
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),

        // Optional icon
        suffixIcon: suffixIcon,

        // Error text style
        errorStyle: TextStyle(
          fontFamily: 'BeVietnamPro',
          fontSize: 9,
          color: Colors.red[400],
        ),
      ),
    );
  }

  // Build password field
  static Widget buildPasswordField({
    required TextEditingController controller,
    required bool isVisible,
    required bool hasText,
    required VoidCallback onToggleVisibility,
    String? Function(String?)? validator,
    required bool isDark,
  }) {
    return TextFormField(
      controller: controller,

      // Hide/show password
      obscureText: !isVisible,

      validator: validator ?? (v) => validateRequired(v, 'Password'),

      // Text style
      style: TextStyle(
        fontFamily: 'BeVietnamPro',
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: isDark ? Colors.white : const Color(0xFF1A1A1A),
      ),

      // Field decoration
      decoration: InputDecoration(
        hintText: '••••••••',

        // Hint style
        hintStyle: TextStyle(
          fontFamily: 'BeVietnamPro',
          fontSize: 14,
          color: isDark
              ? Colors.white.withValues(alpha: 0.3)
              : AppColors.textSecondary.withValues(alpha: 0.4),
        ),

        filled: true,

        // Background color
        fillColor: isDark
            ? Colors.white.withValues(alpha: 0.08)
            : AppColors.secondary.withValues(alpha: 0.5),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 1.5,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),

        // Show visibility icon if text exists
        suffixIcon: hasText
            ? IconButton(
                icon: Icon(
                  isVisible
                      ? Icons.visibility_off
                      : Icons.visibility,

                  color: isDark
                      ? Colors.white60
                      : AppColors.textSecondary,

                  size: 18,
                ),

                // Toggle password visibility
                onPressed: onToggleVisibility,
              )
            : null,

        // Error text style
        errorStyle: TextStyle(
          fontFamily: 'BeVietnamPro',
          fontSize: 9,
          color: Colors.red[400],
        ),
      ),
    );
  }

  // Build social login button
  static Widget buildSocialButton({
    required IconData icon,
    required String label,
    required Color color,
    required bool isDark,
    VoidCallback? onTap,
  }) {
    return SizedBox(
      width: 140,

      child: GestureDetector(
        onTap: onTap,

        child: Container(
          height: 44,

          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : AppColors.white,

            borderRadius: BorderRadius.circular(10),

            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : AppColors.neutral.withValues(alpha: 0.1),
            ),
          ),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Icon(icon, size: 22, color: color),

              const SizedBox(width: 6),

              // Button text
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'BeVietnamPro',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? Colors.white
                      : AppColors.neutral,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build gradient button
  static Widget buildGradientButton({
    required String text,
    required bool isLoading,
    required VoidCallback onTap,
    Widget? suffixIcon,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 48,

      child: GestureDetector(
        onTap: isLoading ? null : onTap,

        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),

            // Button gradient
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

            // Button shadow
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.4),
                blurRadius: 15,
                spreadRadius: 1,
                offset: const Offset(0, 6),
              ),
            ],
          ),

          child: Center(
            child: isLoading

                // Loading indicator
                ? const SizedBox(
                    width: 20,
                    height: 20,

                    child: CircularProgressIndicator(
                      color: AppColors.white,
                      strokeWidth: 2,
                    ),
                  )

                // Button content
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      Text(
                        text,
                        style: const TextStyle(
                          fontFamily: 'BeVietnamPro',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                      ),

                      // Optional icon
                      if (suffixIcon != null) ...[
                        const SizedBox(width: 6),
                        suffixIcon,
                      ],
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  // Build divider between login methods
  static Widget buildOrDivider(bool isDark) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: isDark
                ? Colors.white.withValues(alpha: 0.1)
                : AppColors.neutral.withValues(alpha: 0.1),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),

          child: Text(
            'OR CONTINUE WITH',

            style: TextStyle(
              fontFamily: 'BeVietnamPro',
              fontSize: 9,
              letterSpacing: 1.5,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.4)
                  : AppColors.textSecondary.withValues(alpha: 0.6),
            ),
          ),
        ),

        Expanded(
          child: Divider(
            color: isDark
                ? Colors.white.withValues(alpha: 0.1)
                : AppColors.neutral.withValues(alpha: 0.1),
          ),
        ),
      ],
    );
  }

  // Build password strength indicator
  static Widget buildStrengthIndicator(
    Map<String, dynamic> strength,
    bool isDark,
  ) {
    final color = _getStrengthColor(strength['level']);
    final level = strength['level'];
    final strengthValue = strength['strength'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [

        // Strength bars
        Row(
          children: List.generate(4, (index) {
            return Expanded(
              child: Container(
                height: 4,
                margin: const EdgeInsets.only(right: 4),

                decoration: BoxDecoration(
                  color: index < strengthValue
                      ? color
                      : isDark
                          ? Colors.white.withValues(alpha: 0.1)
                          : AppColors.neutral.withValues(alpha: 0.1),

                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),

        const SizedBox(height: 6),

        // Strength level text and requirement icons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            Text(
              level,

              style: TextStyle(
                fontFamily: 'BeVietnamPro',
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
                color: color,
              ),
            ),

            Row(
              children: [
                _buildReqIcon(strength['hasMinLength'], isDark),
                _buildReqIcon(strength['hasLetters'], isDark),
                _buildReqIcon(strength['hasNumbers'], isDark),
                _buildReqIcon(strength['hasSpecialChars'], isDark),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // Return color based on password level
  static Color _getStrengthColor(String level) {
    if (level == 'STRONG') return const Color(0xFF1B5E20);
    if (level == 'MEDIUM') return const Color(0xFFF57C00);

    return const Color(0xFFC62828);
  }

  // Build requirement status icon
  static Widget _buildReqIcon(bool met, bool isDark) {
    return Icon(
      met ? Icons.check : Icons.circle,

      size: 6,

      color: met
          ? const Color(0xFF1B5E20)
          : isDark
              ? Colors.white.withValues(alpha: 0.3)
              : AppColors.textSecondary.withValues(alpha: 0.3),
    );
  }
}