// lib/models/checkout_model.dart

class PaymentMethod {
  final String id;
  final String name;
  final String icon;

  PaymentMethod({required this.id, required this.name, required this.icon});

  static List<PaymentMethod> getMethods() {
    return [
      PaymentMethod(id: 'cash', name: 'Cash on Delivery', icon: '💵'),
      PaymentMethod(id: 'card', name: 'Credit Card', icon: '💳'),
      PaymentMethod(id: 'paypal', name: 'PayPal', icon: '🅿️'),
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
        name: 'John Doe',
        address: '123 Main Street, Apt 4B',
        city: 'New York, NY 10001',
        phone: '+1 (555) 123-4567',
        isDefault: true,
      ),
    ];
  }
}
