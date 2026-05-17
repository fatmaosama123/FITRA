// lib/views/product/product_details_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/product_details_controller.dart';
import '../../controllers/cart_controller.dart';
import '../../models/cart_item.dart';
import '../../models/product_model.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/fonts.dart';
import '../../widgets/custom_app_bar.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final controller = ProductDetailsController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final product = ModalRoute.of(context)?.settings.arguments as ProductModel?;
    controller.init(product);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _addToCart() {
    final product = controller.product;
    if (product == null) return;

    final cartController = context.read<CartController>();

    final cartItem = CartItem(
      id: product.id,
      name: product.name,
      imageUrl: product.imageUrl,
      price: product.price,
      size: controller.selectedSize,
      color: controller.selectedColorName,
      quantity: controller.quantity,
    );

    cartController.addItem(cartItem);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Added to cart successfully!',
                style: TextStyle(
                  fontFamily: AppFonts.label,
                  fontWeight: FontWeight.w600,
                  color: AppColors.neutral,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: Colors.black.withValues(alpha: 0.05),
            width: 1,
          ),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
        elevation: 8,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: bgColor,

          appBar: CustomAppBar(
            title: controller.product?.name ?? 'Product Details',
            showMenu: false,
            showNotification: true,
            notificationCount: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: isDark ? AppColors.white : AppColors.neutral,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                if (controller.product != null)
                  Hero(
                    tag: 'product_${controller.product!.id}',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Image.network(
                          controller.product!.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.image_not_supported,
                                size: 50,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 24),

                Text(
                  controller.product?.name ?? '',
                  style: TextStyle(
                    fontFamily: AppFonts.headline,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.neutral,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  '\$${controller.product?.price.toStringAsFixed(2) ?? '0.00'}',
                  style: TextStyle(
                    fontFamily: AppFonts.label,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  'Select Color',
                  style: TextStyle(
                    fontFamily: AppFonts.headline,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AppColors.neutral,
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
                  'Select Size',
                  style: TextStyle(
                    fontFamily: AppFonts.headline,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AppColors.neutral,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: List.generate(
                    controller.sizes.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: controller.buildSizeButton(index),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                controller.buildExpandableCard(
                  icon: Icons.eco_outlined,
                  title: 'Material & Care',
                  content: const [
                    '100% Organic Cotton',
                    'Machine wash cold',
                    'Tumble dry low',
                    'Made in Portugal',
                  ],
                  isExpanded: controller.isMaterialExpanded,
                  onToggle: controller.toggleMaterial,
                ),

                const SizedBox(height: 12),

                controller.buildExpandableCard(
                  icon: Icons.local_shipping_outlined,
                  title: 'Shipping & Returns',
                  content: const [
                    'Free shipping on orders over \$150',
                    'Standard delivery: 3-5 business days',
                    'Express delivery: 1-2 business days',
                    'Free returns within 30 days',
                  ],
                  isExpanded: controller.isShippingExpanded,
                  onToggle: controller.toggleShipping,
                ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    Text(
                      'Quantity',
                      style: TextStyle(
                        fontFamily: AppFonts.headline,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : AppColors.neutral,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.08)
                            : Colors.black.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.remove,
                              size: 18,
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                            onPressed: controller.decrementQuantity,
                          ),
                          Text(
                            '${controller.quantity}',
                            style: TextStyle(
                              fontFamily: AppFonts.label,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppColors.white
                                  : AppColors.neutral,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.add,
                              size: 18,
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                            onPressed: controller.incrementQuantity,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                GestureDetector(
                  onTap: _addToCart,
                  child: Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.primary.withValues(alpha: 0.8),
                          AppColors.primary,
                          AppColors.primary.withValues(alpha: 0.9),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          blurRadius: 40,
                          offset: const Offset(0, 20),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.shopping_bag_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'ADD TO CART',
                          style: TextStyle(
                            fontFamily: AppFonts.label,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }
}
