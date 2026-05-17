// lib/routes/app_routes.dart

import 'package:flutter/material.dart';
import 'route_names.dart';

// Auth
import '../views/auth/splash_screen.dart';
import '../views/auth/onboarding_screen.dart';
import '../views/auth/login_screen.dart';
import '../views/auth/signup_screen.dart';
import '../views/auth/forgot_password_screen.dart';

// Main
import '../views/main_layout.dart';

// Home
import '../views/home/home_screen.dart';

// Category
import '../views/category/category_details_screen.dart';

// Shop
import '../views/shop/collection_details_screen.dart';

// Product
import '../views/product/product_details_screen.dart';

// Cart
import '../views/cart/cart_screen.dart';

// Checkout
import '../views/checkout/checkout_screen.dart';

// Profile
import '../views/profile/profile_screen.dart';
import '../views/profile/edit_profile_screen.dart'; // ✅ جديد

// Try-On
import '../views/try_on/try_on_screen.dart';

// Notifications
import '../views/notifications/notifications_screen.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> get routes => {
    // Auth
    RouteNames.splash: (context) => const SplashScreen(),
    RouteNames.onboarding: (context) => const OnboardingScreen(),
    RouteNames.login: (context) => const LoginScreen(),
    RouteNames.signup: (context) => const SignUpScreen(),
    RouteNames.forgotPassword: (context) => const ForgotPasswordScreen(),

    // Main
    RouteNames.mainLayout: (context) => const MainLayout(),

    // Home
    RouteNames.home: (context) => const HomeScreen(),

    // Category
    RouteNames.categoryDetails: (context) => const CategoryDetailsScreen(),

    // Collection Details
    RouteNames.collectionDetails: (context) => const CollectionDetailsScreen(),

    // Product
    RouteNames.productDetails: (context) => const ProductDetailsScreen(),

    // Cart
    RouteNames.cart: (context) => const CartScreen(),

    // Checkout
    RouteNames.checkout: (context) => const CheckoutScreen(),

    // Profile
    RouteNames.profile: (context) => const ProfileScreen(),
    RouteNames.editProfile: (context) => const EditProfileScreen(), // ✅ جديد
    // Try-On
    RouteNames.tryOn: (context) => const TryOnScreen(),

    // Notifications
    RouteNames.notifications: (context) => const NotificationsScreen(),
  };

  static void goToMain(BuildContext context) {
    Navigator.pushReplacementNamed(context, RouteNames.mainLayout);
  }

  static void goToLogin(BuildContext context) {
    Navigator.pushNamed(context, RouteNames.login);
  }

  static void goToSignup(BuildContext context) {
    Navigator.pushNamed(context, RouteNames.signup);
  }

  static void goToForgotPassword(BuildContext context) {
    Navigator.pushNamed(context, RouteNames.forgotPassword);
  }

  static void goToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      RouteNames.home,
      (route) => false,
    );
  }

  static void goToCategoryDetails(BuildContext context, String category) {
    Navigator.pushNamed(
      context,
      RouteNames.categoryDetails,
      arguments: category,
    );
  }

  static void goToCollectionDetails(BuildContext context, String title) {
    Navigator.pushNamed(
      context,
      RouteNames.collectionDetails,
      arguments: title,
    );
  }

  static void goToProductDetails(BuildContext context, dynamic product) {
    Navigator.pushNamed(context, RouteNames.productDetails, arguments: product);
  }

  static void goToCart(BuildContext context) {
    Navigator.pushNamed(context, RouteNames.cart);
  }

  static void goToCheckout(BuildContext context) {
    Navigator.pushNamed(context, RouteNames.checkout);
  }

  static void goToProfile(BuildContext context) {
    Navigator.pushNamed(context, RouteNames.profile);
  }

  // ✅ جديد
  static void goToEditProfile(BuildContext context) {
    Navigator.pushNamed(context, RouteNames.editProfile);
  }

  static void goToTryOn(BuildContext context) {
    Navigator.pushNamed(context, RouteNames.tryOn);
  }

  static void goToNotifications(BuildContext context) {
    Navigator.pushNamed(context, RouteNames.notifications);
  }

  static void goBack(BuildContext context) {
    Navigator.pop(context);
  }
}
