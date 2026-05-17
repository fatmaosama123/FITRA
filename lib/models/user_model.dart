// lib/models/user_model.dart

class UserModel {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final String phone;
  final String memberType;
  final String language;
  final String currency;
  final bool isDarkMode;
  final List<AddressModel> addresses;
  final List<PaymentMethodModel> paymentMethods;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.phone = '',
    this.memberType = 'Standard',
    this.language = 'English (US)',
    this.currency = 'USD (\$)',
    this.isDarkMode = false,
    this.addresses = const [],
    this.paymentMethods = const [],
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    String? phone,
    String? memberType,
    String? language,
    String? currency,
    bool? isDarkMode,
    List<AddressModel>? addresses,
    List<PaymentMethodModel>? paymentMethods,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      phone: phone ?? this.phone,
      memberType: memberType ?? this.memberType,
      language: language ?? this.language,
      currency: currency ?? this.currency,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      addresses: addresses ?? this.addresses,
      paymentMethods: paymentMethods ?? this.paymentMethods,
    );
  }

  factory UserModel.empty() {
    return UserModel(id: '', name: '', email: '', memberType: 'Standard');
  }

  bool get isLoggedIn => id.isNotEmpty;
}

class AddressModel {
  final String id;
  final String name;
  final String address;
  final String city;
  final String phone;
  final bool isDefault;

  AddressModel({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.phone,
    this.isDefault = false,
  });
}

class PaymentMethodModel {
  final String id;
  final String name;
  final String icon;
  final String last4;
  final bool isDefault;

  PaymentMethodModel({
    required this.id,
    required this.name,
    required this.icon,
    this.last4 = '',
    this.isDefault = false,
  });
}
