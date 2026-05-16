// lib/models/checkout_model.dart

class PaymentMethod {
  final String id;
  final String name;
  final String icon;
  final bool isDefault;

  PaymentMethod({
    required this.id,
    required this.name,
    required this.icon,
    this.isDefault = false,
  });

  static List<PaymentMethod> getMethods() {
    return [
      PaymentMethod(
        id: 'cash',
        name: 'Cash on Delivery',
        icon: '💵',
        isDefault: true,
      ),
      PaymentMethod(id: 'visa', name: 'Visa / Mastercard', icon: '💳'),
      PaymentMethod(id: 'apple_pay', name: 'Apple Pay', icon: '🍎'),
    ];
  }
}

class ShippingAddress {
  final String id;
  final String name;
  final String address;
  final String city;
  final String phone;
  final bool isDefault;

  ShippingAddress({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.phone,
    this.isDefault = false,
  });

  static List<ShippingAddress> getAddresses() {
    return [
      ShippingAddress(
        id: '1',
        name: 'Sarah Johnson',
        address: '123 Fashion Avenue, Apt 4B',
        city: 'New York, NY 10001',
        phone: '+1 (555) 123-4567',
        isDefault: true,
      ),
    ];
  }
}
