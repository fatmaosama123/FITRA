// lib/views/profile/edit_profile_screen.dart

import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/edit_profile_controller.dart';
import '../../controllers/profile_controller.dart';
import '../../controllers/navigation_controller.dart'; // ✅ جديد
import '../../core/constants/colors.dart';
import '../../core/constants/fonts.dart';
import '../../widgets/custom_app_bar.dart';
// ❌ شيلنا import '../../widgets/bottom_nav_bar.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ChangeNotifierProvider(
      create: (_) => EditProfileController(),
      child: Consumer<EditProfileController>(
        builder: (context, controller, child) {
          return Scaffold(
            backgroundColor: isDark
                ? AppColors.backgroundDark
                : AppColors.backgroundLight,
            appBar: CustomAppBar(
              title: 'Edit Profile',
              showNotification: false,
              showMenu: false,
              leading: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : const Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    size: 18,
                    color: isDark ? AppColors.white : AppColors.neutral,
                  ),
                ),
              ),
              actions: [_buildSaveButton(controller, context)],
            ),
            // ❌ شيلنا الـ bottomNavigationBar
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildAvatarSection(controller, isDark, context),
                  const SizedBox(height: 32),
                  _buildInfoCard(controller, isDark, context),
                  const SizedBox(height: 24),
                  _buildPasswordCard(controller, isDark),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSaveButton(
    EditProfileController controller,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: controller.isLoading ? null : () => _save(context, controller),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: controller.isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                  ),
                )
              : Text(
                  'Save',
                  style: TextStyle(
                    fontFamily: AppFonts.label,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildAvatarSection(
    EditProfileController controller,
    bool isDark,
    BuildContext context,
  ) {
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: controller.selectedImage != null
                      ? Image.file(controller.selectedImage!, fit: BoxFit.cover)
                      : (controller.avatarUrl != null &&
                            controller.avatarUrl!.isNotEmpty)
                      ? Image.network(
                          controller.avatarUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              _buildInitials(controller),
                        )
                      : _buildInitials(controller),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => _showImagePicker(context, controller),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryDark],
                      ),
                      shape: BoxShape.circle,
                      border: Border.fromBorderSide(
                        BorderSide(color: AppColors.white, width: 2),
                      ),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            controller.nameController.text,
            style: TextStyle(
              fontFamily: AppFonts.headline,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.white : AppColors.neutral,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            controller.emailController.text,
            style: TextStyle(
              fontFamily: AppFonts.body,
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitials(EditProfileController controller) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
      ),
      child: Center(
        child: Text(
          controller.userInitials,
          style: const TextStyle(
            fontFamily: AppFonts.headline,
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }

  void _showImagePicker(
    BuildContext context,
    EditProfileController controller,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.neutral : AppColors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  color: AppColors.textSecondary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Change Photo',
                style: TextStyle(
                  fontFamily: AppFonts.headline,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.white : AppColors.neutral,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: AppColors.primary),
                title: Text(
                  'Camera',
                  style: TextStyle(fontFamily: AppFonts.body),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  await controller.pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_library,
                  color: AppColors.primary,
                ),
                title: Text(
                  'Gallery',
                  style: TextStyle(fontFamily: AppFonts.body),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  await controller.pickImage(ImageSource.gallery);
                },
              ),
              if (controller.selectedImage != null ||
                  (controller.avatarUrl != null &&
                      controller.avatarUrl!.isNotEmpty))
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: Text(
                    'Remove',
                    style: TextStyle(
                      fontFamily: AppFonts.body,
                      color: Colors.red,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    controller.removeAvatar();
                  },
                ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    EditProfileController controller,
    bool isDark,
    BuildContext context,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.neutral : AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildCardHeader(
            Icons.person_outline,
            'Personal Information',
            isDark,
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildField(
                  controller.nameController,
                  'Full Name',
                  Icons.person_outline,
                  isDark,
                ),
                const SizedBox(height: 16),
                _buildField(
                  controller.emailController,
                  'Email',
                  Icons.email_outlined,
                  isDark,
                  TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                _buildField(
                  controller.phoneController,
                  'Phone',
                  Icons.phone_outlined,
                  isDark,
                  TextInputType.phone,
                ),
                const SizedBox(height: 16),
                _buildField(
                  controller.bioController,
                  'Bio',
                  Icons.edit_note_outlined,
                  isDark,
                  null,
                  3,
                ),
                const SizedBox(height: 16),
                _buildDateField(controller, isDark, context),
                const SizedBox(height: 16),
                _buildGenderRow(controller, isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordCard(EditProfileController controller, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.neutral : AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildCardHeader(Icons.lock_outline, 'Change Password', isDark),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildPassField(
                  controller,
                  'Current Password',
                  controller.currentPasswordController,
                  controller.isCurrentPasswordVisible,
                  controller.toggleCurrentPasswordVisibility,
                  isDark,
                ),
                const SizedBox(height: 16),
                _buildPassField(
                  controller,
                  'New Password',
                  controller.newPasswordController,
                  controller.isNewPasswordVisible,
                  controller.toggleNewPasswordVisibility,
                  isDark,
                ),
                const SizedBox(height: 16),
                _buildPassField(
                  controller,
                  'Confirm Password',
                  controller.confirmPasswordController,
                  controller.isConfirmPasswordVisible,
                  controller.toggleConfirmPasswordVisibility,
                  isDark,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardHeader(IconData icon, String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontFamily: AppFonts.headline,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.white : AppColors.neutral,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(
    TextEditingController controller,
    String label,
    IconData icon,
    bool isDark, [
    TextInputType? type,
    int? maxLines,
  ]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: AppFonts.label,
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.white : AppColors.neutral,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: type,
          maxLines: maxLines ?? 1,
          style: TextStyle(
            fontFamily: AppFonts.body,
            fontSize: 15,
            color: isDark ? AppColors.white : AppColors.neutral,
          ),
          decoration: InputDecoration(
            hintText: 'Enter $label',
            hintStyle: TextStyle(
              fontFamily: AppFonts.body,
              fontSize: 15,
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
            prefixIcon: Icon(
              icon,
              size: 20,
              color: AppColors.primary.withValues(alpha: 0.6),
            ),
            filled: true,
            fillColor: isDark
                ? AppColors.neutralLight.withValues(alpha: 0.3)
                : const Color(0xFFF8F8F8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: isDark
                    ? AppColors.neutralLight.withValues(alpha: 0.2)
                    : const Color(0xFFE0E0E0),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPassField(
    EditProfileController ctrl,
    String label,
    TextEditingController controller,
    bool isVisible,
    VoidCallback onToggle,
    bool isDark,
  ) {
    return TextFormField(
      controller: controller,
      obscureText: !isVisible,
      style: TextStyle(
        fontFamily: AppFonts.body,
        fontSize: 15,
        color: isDark ? AppColors.white : AppColors.neutral,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontFamily: AppFonts.label,
          color: AppColors.textSecondary,
        ),
        prefixIcon: Icon(
          Icons.lock_outline,
          size: 20,
          color: AppColors.primary.withValues(alpha: 0.6),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility_off : Icons.visibility,
            size: 20,
            color: AppColors.textSecondary,
          ),
          onPressed: onToggle,
        ),
        filled: true,
        fillColor: isDark
            ? AppColors.neutralLight.withValues(alpha: 0.3)
            : const Color(0xFFF8F8F8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }

  Widget _buildDateField(
    EditProfileController controller,
    bool isDark,
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Birth Date',
          style: TextStyle(
            fontFamily: AppFonts.label,
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.white : AppColors.neutral,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: controller.birthDate ?? DateTime(2000),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
              builder: (context, child) => Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: Theme.of(
                    context,
                  ).colorScheme.copyWith(primary: AppColors.primary),
                ),
                child: child!,
              ),
            );
            if (picked != null) controller.setBirthDate(picked);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.neutralLight.withValues(alpha: 0.3)
                  : const Color(0xFFF8F8F8),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark
                    ? AppColors.neutralLight.withValues(alpha: 0.2)
                    : const Color(0xFFE0E0E0),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 20,
                  color: AppColors.primary.withValues(alpha: 0.6),
                ),
                const SizedBox(width: 12),
                Text(
                  controller.birthDate != null
                      ? controller.formattedBirthDate
                      : 'Select birth date',
                  style: TextStyle(
                    fontFamily: AppFonts.body,
                    fontSize: 15,
                    color: controller.birthDate != null
                        ? (isDark ? AppColors.white : AppColors.neutral)
                        : AppColors.textSecondary.withValues(alpha: 0.5),
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: AppColors.textSecondary.withValues(alpha: 0.4),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderRow(EditProfileController controller, bool isDark) {
    final genders = [
      {'value': 'Male', 'icon': Icons.male},
      {'value': 'Female', 'icon': Icons.female},
      {'value': 'Other', 'icon': Icons.transgender},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender',
          style: TextStyle(
            fontFamily: AppFonts.label,
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.white : AppColors.neutral,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: genders.map((g) {
            final isSelected = controller.gender == g['value'];
            return Expanded(
              child: GestureDetector(
                onTap: () => controller.setGender(g['value'] as String),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.1)
                        : (isDark
                              ? AppColors.neutralLight.withValues(alpha: 0.3)
                              : const Color(0xFFF8F8F8)),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : (isDark
                                ? AppColors.neutralLight.withValues(alpha: 0.2)
                                : const Color(0xFFE0E0E0)),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        g['icon'] as IconData,
                        size: 24,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textSecondary,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        g['value'] as String,
                        style: TextStyle(
                          fontFamily: AppFonts.label,
                          fontSize: 13,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                          color: isSelected
                              ? AppColors.primary
                              : (isDark ? AppColors.white : AppColors.neutral),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _save(BuildContext context, EditProfileController controller) async {
    final success = await controller.saveProfile();
    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              Text(
                'Profile updated!',
                style: TextStyle(fontFamily: AppFonts.body),
              ),
            ],
          ),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
      Navigator.pop(context);
    }
  }
}
