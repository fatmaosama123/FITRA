import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/profile_model.dart';

class EditProfileController extends ChangeNotifier {
  // Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final bioController = TextEditingController();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // State
  ProfileModel _profile = ProfileModel.empty();
  File? _selectedImage;
  bool _isLoading = false;
  DateTime? _birthDate;
  String _gender = '';

  // Password visibility
  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // Getters
  ProfileModel get profile => _profile;
  File? get selectedImage => _selectedImage;
  bool get isLoading => _isLoading;
  DateTime? get birthDate => _birthDate;
  String get gender => _gender;
  String? get avatarUrl => _profile.avatarUrl;

  bool get isCurrentPasswordVisible => _isCurrentPasswordVisible;
  bool get isNewPasswordVisible => _isNewPasswordVisible;
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible;

  String get userInitials {
    if (nameController.text.isEmpty) return '';
    final parts = nameController.text.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return nameController.text[0].toUpperCase();
  }

  String get formattedBirthDate {
    if (_birthDate == null) return '';
    return '${_birthDate!.day.toString().padLeft(2, '0')}/${_birthDate!.month.toString().padLeft(2, '0')}/${_birthDate!.year}';
  }

  EditProfileController() {
    _loadProfile();
  }

  void _loadProfile() {
    // TODO: Replace with actual API call to get current user data
    _profile = ProfileModel(
      id: 'user_123',
      name: 'Fatma Osama ',
      email: 'Fatma.Osama@example.com',
      phone: '+20 123 456 7890',
      avatarUrl:
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400&h=400&fit=crop&crop=face',
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

    // Validation
    if (nameController.text.isEmpty || emailController.text.isEmpty) {
      _isLoading = false;
      notifyListeners();
      return false;
    }

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

    // TODO: Replace with actual API call
    await Future.delayed(const Duration(seconds: 1));

    _profile = _profile.copyWith(
      name: nameController.text,
      email: emailController.text,
      phone: phoneController.text,
      bio: bioController.text,
      birthDate: _birthDate,
      gender: _gender,
      avatarUrl: _selectedImage != null
          ? _selectedImage!.path
          : _profile.avatarUrl,
    );

    _isLoading = false;
    notifyListeners();
    return true;
  }

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
