// lib/views/product/product_details_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/product_details_controller.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/fonts.dart';
import '../../models/product_model.dart';
import '../../models/cart_item.dart'; // ✅ جديد
import '../../routes/app_routes.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/bottom_nav_bar.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final controller = ProductDetailsController();
  int _currentNavIndex = 1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    final product = args is ProductModel ? args : null;
    controller.init(product);
  }

  void _onNavTap(int index) {
    setState(() {
      _currentNavIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
        break;
      case 1:
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/category-details',
          (route) => false,
        );
        break;
      case 2:
        Navigator.pushNamed(context, '/try-on');
        break;
      case 3:
        Navigator.pushNamed(context, '/cart');
        break;
      case 4:
        Navigator.pushNamed(context, '/profile');
        break;
    }
  }

  void _addToCart() {
    final product = controller.product;
    if (product == null) return;

    final cartController = context.read<CartController>();

    final cartItem = CartItem(
      // ✅ CartItem
      id: product.id,
      name: product.name,
      imageUrl: product.imageUrl,
      size: controller.selectedSize,
      color: controller.selectedColorName,
      price: product.price,
      quantity: 1,
    );

    cartController.addItem(cartItem);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'View Cart',
          onPressed: () => AppRoutes.goToCart(context),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final product = controller.product;
        final isDark = Theme.of(context).brightness == Brightness.dark;

        final name = product?.name ?? 'Sculptural Ribbed Cardigan';
        final subtitle = product?.subtitle ?? 'ESSENTIALS COLLECTION';
        final price = product?.price ?? 185.00;
        final imageUrl =
            product?.imageUrl ?? 'assets/images/products/sweater.png';

        return Scaffold(
          backgroundColor: isDark ? AppColors.backgroundDark : AppColors.white,

          appBar: CustomAppBar(
            title: 'Product Details',
            showMenu: false,
            // ✅ تغيير: showCart → showNotification
          ),

          bottomNavigationBar: CustomBottomNavBar(
            currentIndex: _currentNavIndex,
            onTap: _onNavTap,
          ),

          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  height: 400,
                  color: isDark ? AppColors.neutral : const Color(0xFFE8E8E8),
                  child: _buildProductImage(imageUrl),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              subtitle.toUpperCase(),
                              style: TextStyle(
                                fontFamily: AppFonts.label,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          Text(
                            '\$${price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontFamily: AppFonts.headline,
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Text(
                        name,
                        style: TextStyle(
                          fontFamily: AppFonts.headline,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.white : AppColors.neutral,
                          height: 1.1,
                        ),
                      ),

                      const SizedBox(height: 16),

                      Text(
                        'A masterpiece of tactile minimalism. This cardigan features an architectural silhouette crafted from ethically sourced ultra-fine Merino wool. Designed to drape effortlessly, bridging the gap between structure and softness.',
                        style: TextStyle(
                          fontFamily: AppFonts.body,
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          height: 1.6,
                        ),
                      ),

                      const SizedBox(height: 24),

                      Text(
                        'SELECT COLOR',
                        style: TextStyle(
                          fontFamily: AppFonts.label,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary.withValues(alpha: 0.7),
                          letterSpacing: 1,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: List.generate(
                          controller.colors.length,
                          (index) => Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: controller.buildColorCircle(index, context),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      Text(
                        'SELECT SIZE',
                        style: TextStyle(
                          fontFamily: AppFonts.label,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary.withValues(alpha: 0.7),
                          letterSpacing: 1,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: List.generate(
                          controller.sizes.length,
                          (index) => Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: controller.buildSizeButton(index),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      controller.buildExpandableCard(
                        icon: Icons.eco_outlined,
                        title: 'Material & Care',
                        content: [
                          '• 100% Responsibly sourced Merino wool.',
                          '• Hand wash cold only. Dry flat to maintain silhouette.',
                          '• Naturally breathable and temperature regulating.',
                        ],
                        isExpanded: controller.isMaterialExpanded,
                        onToggle: controller.toggleMaterial,
                      ),

                      const SizedBox(height: 12),

                      controller.buildExpandableCard(
                        icon: Icons.local_shipping_outlined,
                        title: 'Shipping Info',
                        content: [
                          '• Complimentary carbon-neutral standard shipping.',
                          '• Ships within 48 hours from our Lisbon studio.',
                          '• 14-day premium return policy.',
                        ],
                        isExpanded: controller.isShippingExpanded,
                        onToggle: controller.toggleShipping,
                      ),

                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _addToCart,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.shopping_bag_outlined, size: 20),
                              const SizedBox(width: 12),
                              Text(
                                'Add to Cart - \$${price.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontFamily: AppFonts.label,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProductImage(String imageUrl) {
    if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.primary.withValues(alpha: 0.5),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: AppColors.secondary,
            child: Center(
              child: Icon(
                Icons.image_not_supported,
                color: AppColors.textSecondary.withValues(alpha: 0.5),
                size: 40,
              ),
            ),
          );
        },
      );
    } else {
      return Image.asset(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: AppColors.secondary,
            child: Center(
              child: Icon(
                Icons.image_not_supported,
                color: AppColors.textSecondary.withValues(alpha: 0.5),
                size: 40,
              ),
            ),
          );
        },
      );
    }
  }
}
