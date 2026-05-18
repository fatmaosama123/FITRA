// lib/models/user_model.dart

// User data model
class UserModel {
  // User unique id
  final String id;
  // User name
  final String name;
  // User email
  final String email;
  // Avatar image URL
  final String? avatarUrl;
  // User phone number
  final String phone;
  // Membership type
  final String memberType;
  // Selected language
  final String language;
  // Selected currency
  final String currency;
  // Dark mode preference
  final bool isDarkMode;
  // Saved addresses list
  final List<AddressModel> addresses;
  // Saved payment methods list
  final List<PaymentMethodModel> paymentMethods;

  // Constructor
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

  // Copy user with optional field updates
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

  // Create empty user instance
  factory UserModel.empty() {
    return UserModel(id: '', name: '', email: '', memberType: 'Standard');
  }

  // Check if user is logged in
  bool get isLoggedIn => id.isNotEmpty;
}

// Shipping address data model
class AddressModel {
  // Address unique id
  final String id;
  // Recipient name
  final String name;
  // Street address
  final String address;
  // City info
  final String city;
  // Contact phone
  final String phone;
  // Is default address flag
  final bool isDefault;

  // Constructor
  AddressModel({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.phone,
    this.isDefault = false,
  });
}

// Payment method data model
class PaymentMethodModel {
  // Payment method id
  final String id;
  // Payment method name
  final String name;
  // Payment method icon
  final String icon;
  // Last 4 digits of card
  final String last4;
  // Is default payment flag
  final bool isDefault;

  // Constructor
  PaymentMethodModel({
    required this.id,
    required this.name,
    required this.icon,
    this.last4 = '',
    this.isDefault = false,
  });
}