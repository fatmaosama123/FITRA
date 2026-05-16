// lib/models/profile_model.dart

class ProfileModel {
  final String id;
  String name;
  String email;
  String phone;
  String? avatarUrl;
  String bio;
  String gender;
  DateTime? birthDate;

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

  factory ProfileModel.empty() {
    return ProfileModel(id: '', name: '', email: '');
  }

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
