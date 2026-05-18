// lib/models/profile_model.dart

// Profile data model
class ProfileModel {
  // User unique id
  final String id;
  // User name
  String name;
  // User email
  String email;
  // User phone number
  String phone;
  // Avatar image URL
  String? avatarUrl;
  // User bio text
  String bio;
  // User gender
  String gender;
  // User birth date
  DateTime? birthDate;

  // Constructor
  ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone = '',
    this.avatarUrl,
    this.bio = '',
    this.gender = '',
    this.birthDate,
  });

  // Create empty profile instance
  factory ProfileModel.empty() {
    return ProfileModel(id: '', name: '', email: '');
  }

  // Copy profile with optional field updates
  ProfileModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
    String? bio,
    String? gender,
    DateTime? birthDate,
  }) {
    return ProfileModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
    );
  }
}