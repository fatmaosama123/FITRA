// lib/models/try_on_model.dart

// Try-on product data model
class TryOnProduct {
  // Product unique id
  final String id;
  // Product name
  final String name;
  // Product subtitle
  final String subtitle;
  // Product price
  final double price;
  // Product image URL from Unsplash
  final String imageUrl;
  // Available colors list
  final List<String> colors;

  // Constructor
  TryOnProduct({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.price,
    required this.imageUrl,
    required this.colors,
  });

  // Get recommended products for try-on
  static List<TryOnProduct> getRecommended() {
    return [
      TryOnProduct(
        id: '1',
        name: 'Linen Trousers',
        subtitle: '',
        price: 120,
        imageUrl:
            'https://images.unsplash.com/photo-1594633312681-425c7b97ccd1?w=400&h=600&fit=crop',
        colors: [],
      ),
      TryOnProduct(
        id: '2',
        name: 'Organic Cotton Tee',
        subtitle: '',
        price: 45,
        imageUrl:
            'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400&h=600&fit=crop',
        colors: [],
      ),
      TryOnProduct(
        id: '3',
        name: 'Artisan Loafers',
        subtitle: '',
        price: 210,
        imageUrl:
            'https://images.unsplash.com/photo-1614252369475-531eba835eb1?w=400&h=600&fit=crop',
        colors: [],
      ),
      TryOnProduct(
        id: '4',
        name: 'Recycled Puffer',
        subtitle: '',
        price: 185,
        imageUrl:
            'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=400&h=600&fit=crop',
        colors: [],
      ),
    ];
  }
}