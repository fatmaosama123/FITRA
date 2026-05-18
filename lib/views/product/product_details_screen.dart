// lib/views/product/product_details_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/product_details_controller.dart';
import '../../controllers/cart_controller.dart';
import '../../models/product_model.dart';
import '../../core/constants/colors.dart';
import '../../widgets/custom_app_bar.dart';

// Product details screen with add to cart
class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  // Product details controller
  final controller = ProductDetailsController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get product from route arguments
    final product = ModalRoute.of(context)?.settings.arguments as ProductModel?;
    controller.init(product);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // Add product to cart and show snackbar
  void _addToCart() {
    final cartItem = controller.buildCartItem();
    if (cartItem == null) return;

    // Add to cart
    context.read<CartController>().addItem(cartItem);

    // Show success snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      controller.buildSuccessSnackBar() as SnackBar,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) => Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,

        // Custom app bar
        appBar: CustomAppBar(
          title: controller.product?.name ?? 'Product Details',
          showMenu: false,
          showNotification: true,
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
              // Product image with hero
              controller.buildProductImage(isDark),
              const SizedBox(height: 24),
              // Product name
              controller.buildProductName(isDark),
              const SizedBox(height: 8),
              // Product price
              controller.buildProductPrice(),
              const SizedBox(height: 24),
              // Color selection
              controller.buildColorSection(isDark),
              const SizedBox(height: 24),
              // Size selection
              controller.buildSizeSection(isDark),
              const SizedBox(height: 24),
              // Material & care expandable
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
              // Shipping & returns expandable
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
              // Quantity selector
              controller.buildQuantitySelector(isDark),
              const SizedBox(height: 24),
              // Add to cart button
              controller.buildAddToCartButton(_addToCart),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}