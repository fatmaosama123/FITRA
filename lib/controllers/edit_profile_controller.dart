// lib/controllers/edit_profile_controller.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/profile_model.dart';
import '../core/constants/colors.dart';
import '../core/constants/fonts.dart';

// Manages profile editing state and UI builders
class EditProfileController extends ChangeNotifier {

  // ─── Text Controllers ───

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final bioController = TextEditingController();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // ─── State ───

  ProfileModel _profile = ProfileModel.empty();
  File? _selectedImage;
  bool _isLoading = false;
  DateTime? _birthDate;
  String _gender = '';

  // ─── Password Visibility ───

  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // ─── Getters ───

  ProfileModel get profile => _profile;
  File? get selectedImage => _selectedImage;
  bool get isLoading => _isLoading;
  DateTime? get birthDate => _birthDate;
  String get gender => _gender;
  String? get avatarUrl => _profile.avatarUrl;
  bool get isCurrentPasswordVisible => _isCurrentPasswordVisible;
  bool get isNewPasswordVisible => _isNewPasswordVisible;
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible;

  // User initials from name
  String get userInitials {
    if (nameController.text.isEmpty) return '';
    final parts = nameController.text.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return nameController.text[0].toUpperCase();
  }

  // Formatted birth date DD/MM/YYYY
  String get formattedBirthDate {
    if (_birthDate == null) return '';
    return '${_birthDate!.day.toString().padLeft(2, '0')}/${_birthDate!.month.toString().padLeft(2, '0')}/${_birthDate!.year}';
  }

  // ─── Init ───

  EditProfileController() {
    _loadProfile();
  }

  void _loadProfile() {
    // TODO: Replace with API call
    _profile = ProfileModel(
      id: 'user_123',
      name: 'Fatma Osama',
      email: 'Fatma.Osama@example.com',
      phone: '+20 123 456 7890',
      avatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400&h=400&fit=crop&crop=face',
      bio: 'Flutter Developer',
      gender: 'Female',
      birthDate: DateTime(2000, 5, 15),
    );

    nameController.text = _profile.name;
    emailController.text = _profile.email;
    phoneController.text = _profile.phone;
    bioController.text = _profile.bio;
    _birthDate = _profile.birthDate;
    _gender = _profile.gender;

    notifyListeners();
  }

  // ─── Methods ───

  Future<File?> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      _selectedImage = File(pickedFile.path);
      notifyListeners();
      return _selectedImage;
    }
    return null;
  }

  void removeAvatar() {
    _selectedImage = null;
    _profile = _profile.copyWith(avatarUrl: null);
    notifyListeners();
  }

  void setBirthDate(DateTime date) {
    _birthDate = date;
    notifyListeners();
  }

  void setGender(String gender) {
    _gender = gender;
    notifyListeners();
  }

  void toggleCurrentPasswordVisibility() {
    _isCurrentPasswordVisible = !_isCurrentPasswordVisible;
    notifyListeners();
  }

  void toggleNewPasswordVisibility() {
    _isNewPasswordVisible = !_isNewPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    notifyListeners();
  }

  Future<bool> saveProfile() async {
    _isLoading = true;
    notifyListeners();

    // Validate required fields
    if (nameController.text.isEmpty || emailController.text.isEmpty) {
      _isLoading = false;
      notifyListeners();
      return false;
    }

    // Validate password change
    if (newPasswordController.text.isNotEmpty) {
      if (currentPasswordController.text.isEmpty) {
        _isLoading = false;
        notifyListeners();
        return false;
      }
      if (newPasswordController.text != confirmPasswordController.text) {
        _isLoading = false;
        notifyListeners();
        return false;
      }
    }

    // TODO: Replace with API call
    await Future.delayed(const Duration(seconds: 1));

    _profile = _profile.copyWith(
      name: nameController.text,
      email: emailController.text,
      phone: phoneController.text,
      bio: bioController.text,
      birthDate: _birthDate,
      gender: _gender,
      avatarUrl: _selectedImage != null ? _selectedImage!.path : _profile.avatarUrl,
    );

    _isLoading = false;
    notifyListeners();
    return true;
  }

  // ─── UI BUILDERS ───

  // Build save button (app bar action)
  Widget buildSaveButton(VoidCallback onSave) => Padding(
        padding: const EdgeInsets.only(right: 8),
        child: GestureDetector(
          onTap: isLoading ? null : onSave,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                    ),
                  )
                : _text('Save', AppFonts.label, 14, AppColors.white, bold: true),
          ),
        ),
      );

  // Build avatar section with image picker
  Widget buildAvatarSection(bool isDark, VoidCallback onCameraTap) => Center(
        child: Column(
          children: [
            Stack(
              children: [
                // Avatar container
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
                    child: _selectedImage != null
                        ? Image.file(_selectedImage!, fit: BoxFit.cover)
                        : (avatarUrl != null && avatarUrl!.isNotEmpty)
                            ? Image.network(
                                avatarUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => _buildInitials(),
                              )
                            : _buildInitials(),
                  ),
                ),
                // Camera button
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: onCameraTap,
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
            // User name
            _text(nameController.text, AppFonts.headline, 20,
                isDark ? AppColors.white : AppColors.neutral,
                bold: true),
            const SizedBox(height: 2),
            // User email
            _text(emailController.text, AppFonts.body, 13, AppColors.textSecondary),
          ],
        ),
      );

  // Build initials fallback
  Widget _buildInitials() => Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.primaryDark],
          ),
        ),
        child: Center(
          child: _text(userInitials, AppFonts.headline, 32, AppColors.white,
              bold: true),
        ),
      );

  // Build image picker bottom sheet
  Widget buildImagePickerSheet(
    bool isDark,
    VoidCallback onCamera,
    VoidCallback onGallery,
    VoidCallback? onRemove,
  ) =>
      Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.neutral : AppColors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
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
              _text('Change Photo', AppFonts.headline, 18,
                  isDark ? AppColors.white : AppColors.neutral,
                  bold: true),
              const SizedBox(height: 16),
              // Camera option
              ListTile(
                leading: const Icon(Icons.camera_alt, color: AppColors.primary),
                title: _text('Camera', AppFonts.body, 14, AppColors.neutral),
                onTap: onCamera,
              ),
              // Gallery option
              ListTile(
                leading: const Icon(Icons.photo_library, color: AppColors.primary),
                title: _text('Gallery', AppFonts.body, 14, AppColors.neutral),
                onTap: onGallery,
              ),
              // Remove option
              if (onRemove != null)
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: _text('Remove', AppFonts.body, 14, Colors.red),
                  onTap: onRemove,
                ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      );

  // Build personal info card
  Widget buildInfoCard(bool isDark, BuildContext context) => _card(
        isDark: isDark,
        child: Column(
          children: [
            _cardHeader(Icons.person_outline, 'Personal Information', isDark),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildField(nameController, 'Full Name', Icons.person_outline, isDark),
                  const SizedBox(height: 16),
                  _buildField(emailController, 'Email', Icons.email_outlined, isDark,
                      TextInputType.emailAddress),
                  const SizedBox(height: 16),
                  _buildField(phoneController, 'Phone', Icons.phone_outlined, isDark,
                      TextInputType.phone),
                  const SizedBox(height: 16),
                  _buildField(bioController, 'Bio', Icons.edit_note_outlined, isDark,
                      null, 3),
                  const SizedBox(height: 16),
                  _buildDateField(isDark, context),
                  const SizedBox(height: 16),
                  _buildGenderRow(isDark),
                ],
              ),
            ),
          ],
        ),
      );

  // Build password change card
  Widget buildPasswordCard(bool isDark) => _card(
        isDark: isDark,
        child: Column(
          children: [
            _cardHeader(Icons.lock_outline, 'Change Password', isDark),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildPassField('Current Password', currentPasswordController,
                      _isCurrentPasswordVisible, toggleCurrentPasswordVisibility, isDark),
                  const SizedBox(height: 16),
                  _buildPassField('New Password', newPasswordController,
                      _isNewPasswordVisible, toggleNewPasswordVisibility, isDark),
                  const SizedBox(height: 16),
                  _buildPassField('Confirm Password', confirmPasswordController,
                      _isConfirmPasswordVisible, toggleConfirmPasswordVisibility, isDark),
                ],
              ),
            ),
          ],
        ),
      );

  // Build success snackbar
  Widget buildSuccessSnackBar() => SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            _text('Profile updated!', AppFonts.body, 14, Colors.white),
          ],
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      );

  // ─── PRIVATE HELPERS ───

  Widget _card({required bool isDark, required Widget child}) => Container(
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
        child: child,
      );

  Widget _cardHeader(IconData icon, String title, bool isDark) => Padding(
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
            _text(title, AppFonts.headline, 16,
                isDark ? AppColors.white : AppColors.neutral,
                bold: true),
          ],
        ),
      );

  Widget _buildField(
    TextEditingController controller,
    String label,
    IconData icon,
    bool isDark, [
    TextInputType? type,
    int? maxLines,
  ]) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _text(label, AppFonts.label, 13,
              isDark ? AppColors.white : AppColors.neutral,
              bold: true),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            keyboardType: type,
            maxLines: maxLines ?? 1,
            style: _textStyle(AppFonts.body, 15,
                isDark ? AppColors.white : AppColors.neutral),
            decoration: _inputDecoration('Enter $label', icon, isDark),
          ),
        ],
      );

  Widget _buildPassField(
    String label,
    TextEditingController controller,
    bool isVisible,
    VoidCallback onToggle,
    bool isDark,
  ) =>
      TextFormField(
        controller: controller,
        obscureText: !isVisible,
        style: _textStyle(AppFonts.body, 15,
            isDark ? AppColors.white : AppColors.neutral),
        decoration: _inputDecoration(label, Icons.lock_outline, isDark).copyWith(
          suffixIcon: IconButton(
            icon: Icon(
              isVisible ? Icons.visibility_off : Icons.visibility,
              size: 20,
              color: AppColors.textSecondary,
            ),
            onPressed: onToggle,
          ),
        ),
      );

  Widget _buildDateField(bool isDark, BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _text('Birth Date', AppFonts.label, 13,
              isDark ? AppColors.white : AppColors.neutral,
              bold: true),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _birthDate ?? DateTime(2000),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
                builder: (context, child) => Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: Theme.of(context)
                        .colorScheme
                        .copyWith(primary: AppColors.primary),
                  ),
                  child: child!,
                ),
              );
              if (picked != null) setBirthDate(picked);
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
                  Icon(Icons.calendar_today_outlined,
                      size: 20, color: AppColors.primary.withValues(alpha: 0.6)),
                  const SizedBox(width: 12),
                  _text(
                    _birthDate != null ? formattedBirthDate : 'Select birth date',
                    AppFonts.body,
                    15,
                    _birthDate != null
                        ? (isDark ? AppColors.white : AppColors.neutral)
                        : AppColors.textSecondary.withValues(alpha: 0.5),
                  ),
                  const Spacer(),
                  Icon(Icons.arrow_forward_ios,
                      size: 14, color: AppColors.textSecondary.withValues(alpha: 0.4)),
                ],
              ),
            ),
          ),
        ],
      );

  Widget _buildGenderRow(bool isDark) {
    final genders = [
      {'value': 'Male', 'icon': Icons.male},
      {'value': 'Female', 'icon': Icons.female},
      {'value': 'Other', 'icon': Icons.transgender},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _text('Gender', AppFonts.label, 13,
            isDark ? AppColors.white : AppColors.neutral,
            bold: true),
        const SizedBox(height: 12),
        Row(
          children: genders.map((g) {
            final isSelected = _gender == g['value'];
            return Expanded(
              child: GestureDetector(
                onTap: () => setGender(g['value'] as String),
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
                        color: isSelected ? AppColors.primary : AppColors.textSecondary,
                      ),
                      const SizedBox(height: 6),
                      _text(
                        g['value'] as String,
                        AppFonts.label,
                        13,
                        isSelected
                            ? AppColors.primary
                            : (isDark ? AppColors.white : AppColors.neutral),
                        bold: isSelected,
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

  InputDecoration _inputDecoration(String hint, IconData icon, bool isDark) =>
      InputDecoration(
        hintText: hint,
        hintStyle: _textStyle(AppFonts.body, 15,
            AppColors.textSecondary.withValues(alpha: 0.5)),
        prefixIcon: Icon(icon, size: 20, color: AppColors.primary.withValues(alpha: 0.6)),
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
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      );

  Widget _text(String text, String font, double size, Color color,
          {bool bold = false}) =>
      Text(
        text,
        style: _textStyle(font, size, color, bold: bold),
      );

  TextStyle _textStyle(String font, double size, Color color,
          {bool bold = false}) =>
      TextStyle(
        fontFamily: font,
        fontSize: size,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        color: color,
      );

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    bioController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}