// lib/models/checkout_model.dart

// Payment method data model
class PaymentMethod {
  // Payment method id
  final String id;
  // Payment method name
  final String name;
  // Payment method icon emoji
  final String icon;

  // Constructor
  PaymentMethod({required this.id, required this.name, required this.icon});

  // Get available payment methods
  static List<PaymentMethod> getMethods() {
    return [
      PaymentMethod(id: 'cash', name: 'Cash on Delivery', icon: '💵'),
      PaymentMethod(id: 'card', name: 'Credit Card', icon: '💳'),
      PaymentMethod(id: 'paypal', name: 'PayPal', icon: '🅿️'),
    ];
  }
}

// Shipping address data model
class ShippingAddress {
  // Address unique id
  final String id;
  // Recipient name
  final String name;
  // Street address
  final String address;
  // City and zip code
  final String city;
  // Contact phone
  final String phone;
  // Is default address flag
  final bool isDefault;

  // Constructor
  ShippingAddress({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.phone,
    this.isDefault = false,
  });

  // Get saved shipping addresses
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