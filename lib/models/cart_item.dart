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

  static List<CartItem> sampleItems() {
    return [
      CartItem(
        id: '1',
        name: 'Sculptural Ribbed Cardigan',
        imageUrl:
            'https://images.unsplash.com/photo-1576566588028-4147f3842f27?w=400&q=80',
        size: 'M',
        color: 'Ivory',
        price: 185.00,
        quantity: 1,
      ),
      CartItem(
        id: '2',
        name: 'Linen Shirt',
        imageUrl:
            'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=400&q=80',
        size: 'L',
        color: 'Beige',
        price: 95.00,
        quantity: 2,
      ),
      CartItem(
        id: '3',
        name: 'Silk Dress',
        imageUrl:
            'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=400&q=80',
        size: 'S',
        color: 'Black',
        price: 195.00,
        quantity: 1,
      ),
    ];
  }
}
