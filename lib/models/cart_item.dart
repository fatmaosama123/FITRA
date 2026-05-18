// lib/models/cart_item.dart

class CartItem {
  final String id;
  final String name;
  final String imageUrl;
  final String? size;
  final String? color;
  final double price;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.size,
    this.color,
    required this.price,
    this.quantity = 1,
  });

  double get totalPrice => price * quantity;

  // Create copy with changes (useful for state updates)
  CartItem copyWith({int? quantity}) => CartItem(
        id: id,
        name: name,
        imageUrl: imageUrl,
        size: size,
        color: color,
        price: price,
        quantity: quantity ?? this.quantity,
      );

  // Sample data for testing
  static List<CartItem> get samples => [
        _item('1', 'Sculptural Ribbed Cardigan', 'Ivory', 'M', 185),
        _item('2', 'Linen Shirt', 'Beige', 'L', 95, qty: 2),
        _item('3', 'Silk Dress', 'Black', 'S', 195),
      ];

  // Helper to create sample item quickly
  static CartItem _item(String id, String name, String color, String size,
          double price, {int qty = 1}) =>
      CartItem(
        id: id,
        name: name,
        imageUrl: 'https://images.unsplash.com/photo-${_imageIds[id]}?w=400&q=80',
        size: size,
        color: color,
        price: price,
        quantity: qty,
      );

  static const _imageIds = {
    '1': '1576566588028-4147f3842f27',
    '2': '1596755094514-f87e34085b2c',
    '3': '1595777457583-95e059d581b8',
  };
}