// lib/views/profile/edit_profile_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/edit_profile_controller.dart';
import '../../core/constants/colors.dart';
import '../../widgets/custom_app_bar.dart';

// Edit profile screen with avatar, info, and password
class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ChangeNotifierProvider(
      create: (_) => EditProfileController(),
      child: Consumer<EditProfileController>(
        builder: (context, controller, _) => Scaffold(
          backgroundColor: isDark
              ? AppColors.backgroundDark
              : AppColors.backgroundLight,

          // Custom app bar with save button
          appBar: CustomAppBar(
            title: 'Edit Profile',
            showNotification: false,
            showMenu: false,
            // Back button
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
            // Save button from controller
            actions: [
              controller.buildSaveButton(() => _save(context, controller)),
            ],
          ),

          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Avatar section from controller
                controller.buildAvatarSection(
                  isDark,
                  () => _showImagePicker(context, controller, isDark),
                ),
                const SizedBox(height: 32),
                // Personal info card from controller
                controller.buildInfoCard(isDark, context),
                const SizedBox(height: 24),
                // Password change card from controller
                controller.buildPasswordCard(isDark),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Show image picker bottom sheet
  void _showImagePicker(
    BuildContext context,
    EditProfileController controller,
    bool isDark,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => controller.buildImagePickerSheet(
        isDark,
        // Camera
        () async {
          Navigator.pop(context);
          await controller.pickImage(ImageSource.camera);
        },
        // Gallery
        () async {
          Navigator.pop(context);
          await controller.pickImage(ImageSource.gallery);
        },
        // Remove (if image exists)
        (controller.selectedImage != null ||
                (controller.avatarUrl != null && controller.avatarUrl!.isNotEmpty))
            ? () {
                Navigator.pop(context);
                controller.removeAvatar();
              }
            : null,
      ),
    );
  }

  // Save profile and show success
  Future<void> _save(BuildContext context, EditProfileController controller) async {
    final success = await controller.saveProfile();
    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        controller.buildSuccessSnackBar() as SnackBar,
      );
      Navigator.pop(context);
    }
  }
}