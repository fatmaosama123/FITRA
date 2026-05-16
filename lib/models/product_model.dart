// lib/models/product_model.dart

class ProductModel {
  final String id;
  final String name;
  final String subtitle;
  final double price;
  final String imageUrl;
  final String? badge;
  final String category;
  // ← جديد
  final bool isNewArrival;

  ProductModel({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.price,
    required this.imageUrl,
    this.badge,
    required this.category,
    // ← جديد
    this.isNewArrival = false,
  });

  // Mock data - New Arrivals (زي ما هو بالظبط)
  static List<ProductModel> get newArrivals => [
    ProductModel(
      id: '1',
      name: 'Canvas Blazer',
      subtitle: 'Earth Edition',
      price: 189.00,
      imageUrl: 'assets/images/products/blazer.png',
      category: 'Essentials',
    ),
    ProductModel(
      id: '2',
      name: 'Raw Edge Denim',
      subtitle: 'Classic Fit',
      price: 145.00,
      imageUrl: 'assets/images/products/denim.png',
      category: 'Denim',
    ),
    ProductModel(
      id: '3',
      name: 'Wide Leg Trouser',
      subtitle: 'Recycled Cotton',
      price: 120.00,
      imageUrl: 'assets/images/products/trouser.png',
      badge: 'SUSTAINABLE',
      category: 'Essentials',
    ),
    ProductModel(
      id: '4',
      name: 'Essential T-Shirt',
      subtitle: 'Set of 3',
      price: 75.00,
      imageUrl: 'assets/images/products/tshirt.png',
      category: 'Essentials',
    ),
    ProductModel(
      id: '5',
      name: 'Pleated Midi Skirt',
      subtitle: 'Sage Green',
      price: 95.00,
      imageUrl: 'assets/images/products/skirt.png',
      category: 'Essentials',
    ),
  ];

  // Mock data - Trending (زي ما هو بالظبط)
  static List<ProductModel> get trending => [
    ProductModel(
      id: '6',
      name: 'Linen Shirt',
      subtitle: 'Summer Collection',
      price: 85.00,
      imageUrl: 'assets/images/products/linen.png',
      category: 'Essentials',
    ),
    ProductModel(
      id: '7',
      name: 'Oversized Coat',
      subtitle: 'Winter Edition',
      price: 245.00,
      imageUrl: 'assets/images/products/coat.png',
      badge: 'NEW',
      category: 'Essentials',
    ),
  ];

  // ← جديد: كل المنتجات من Unsplash (لصفحة الـ Product Listing)
  static List<ProductModel> get allProducts => [
    // Streetwear
    ProductModel(
      id: 'sw1',
      name: 'Heavyweight Oversized Hoodie',
      subtitle: 'Stone Wash',
      price: 85.00,
      imageUrl:
          'https://images.unsplash.com/photo-1556821840-3a63f95609a7?w=400',
      badge: 'NEW ARRIVAL',
      category: 'Streetwear',
      isNewArrival: true,
    ),
    ProductModel(
      id: 'sw2',
      name: 'Modular Cargo Pants',
      subtitle: 'Dark Olive',
      price: 120.00,
      imageUrl:
          'https://images.unsplash.com/photo-1624378439575-d8705ad7ae80?w=400',
      category: 'Streetwear',
    ),
    ProductModel(
      id: 'sw3',
      name: 'Active Pursuit Shorts',
      subtitle: 'Sandstone',
      price: 55.00,
      imageUrl:
          'https://images.unsplash.com/photo-1591195853828-11db59a44f6b?w=400',
      category: 'Streetwear',
    ),

    // Outerwear
    ProductModel(
      id: 'ow1',
      name: 'Insulated Bomber Jacket',
      subtitle: 'Matte Black',
      price: 165.00,
      imageUrl:
          'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=400',
      category: 'Outerwear',
    ),
    ProductModel(
      id: 'ow2',
      name: 'Utility Layering Vest',
      subtitle: 'Coal Grey',
      price: 95.00,
      imageUrl:
          'https://images.unsplash.com/photo-1503342217505-b0a15ec3261c?w=400',
      category: 'Outerwear',
    ),

    // Minimalist
    ProductModel(
      id: 'mn1',
      name: 'Essential 300GSM Tee',
      subtitle: 'Off-White',
      price: 45.00,
      imageUrl:
          'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400',
      category: 'Minimalist',
    ),

    // Denim
    ProductModel(
      id: 'dn1',
      name: 'Wide Leg Relaxed Denim',
      subtitle: 'Ocean Wash',
      price: 110.00,
      imageUrl:
          'https://images.unsplash.com/photo-1542272617-08f086302542?w=400',
      category: 'Denim',
    ),

    // Accessories
    ProductModel(
      id: 'ac1',
      name: 'Ribbed Merino Beanie',
      subtitle: 'Forest Green',
      price: 35.00,
      imageUrl:
          'https://images.unsplash.com/photo-1576871337632-b9aef4c17ab9?w=400',
      category: 'Accessories',
    ),
  ];

  // ← جديد: جلب منتجات حسب الكاتيجوري
  static List<ProductModel> getByCategory(String category) {
    return allProducts.where((product) {
      return product.category.toLowerCase() == category.toLowerCase();
    }).toList();
  }
}
