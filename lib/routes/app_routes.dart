// lib/routes/app_routes.dart

// Flutter material package for navigation
import 'package:flutter/material.dart';
// Route names constants
import 'route_names.dart';

// ─── Auth Screens ───

import '../views/auth/splash_screen.dart';
import '../views/auth/onboarding_screen.dart';
import '../views/auth/login_screen.dart';
import '../views/auth/signup_screen.dart';
import '../views/auth/forgot_password_screen.dart';

// ─── Main Layout ───

import '../views/main_layout.dart';

// ─── Home Screen ───

import '../views/home/home_screen.dart';

// ─── Category Screens ───

import '../views/category/category_details_screen.dart';

// ─── Shop Screens ───

import '../views/shop/collection_details_screen.dart';

// ─── Product Screens ───

import '../views/product/product_details_screen.dart';

// ─── Cart Screen ───

import '../views/cart/cart_screen.dart';

// ─── Checkout Screen ───

import '../views/checkout/checkout_screen.dart';

// ─── Profile Screens ───

import '../views/profile/profile_screen.dart';
import '../views/profile/edit_profile_screen.dart';

// ─── Try-On Screen ───

import '../views/try_on/try_on_screen.dart';

// ─── Notifications Screen ───

import '../views/notifications/notifications_screen.dart';

// App navigation routes manager
class AppRoutes {
  // All app routes map
  static Map<String, WidgetBuilder> get routes => {
    // Auth routes
    RouteNames.splash: (context) => const SplashScreen(),
    RouteNames.onboarding: (context) => const OnboardingScreen(),
    RouteNames.login: (context) => const LoginScreen(),
    RouteNames.signup: (context) => const SignUpScreen(),
    RouteNames.forgotPassword: (context) => const ForgotPasswordScreen(),

    // Main layout route
    RouteNames.mainLayout: (context) => const MainLayout(),

    // Home route
    RouteNames.home: (context) => const HomeScreen(),

    // Category route
    RouteNames.categoryDetails: (context) => const CategoryDetailsScreen(),

    // Collection route
    RouteNames.collectionDetails: (context) => const CollectionDetailsScreen(),

    // Product route
    RouteNames.productDetails: (context) => const ProductDetailsScreen(),

    // Cart route
    RouteNames.cart: (context) => const CartScreen(),

    // Checkout route
    RouteNames.checkout: (context) => const CheckoutScreen(),

    // Profile routes
    RouteNames.profile: (context) => const ProfileScreen(),
    RouteNames.editProfile: (context) => const EditProfileScreen(),

    // Try-On route
    RouteNames.tryOn: (context) => const TryOnScreen(),

    // Notifications route
    RouteNames.notifications: (context) => const NotificationsScreen(),
  };

  // ─── Navigation Helpers ───

  // Go to main layout (replace current screen)
  static void goToMain(BuildContext context) {
    Navigator.pushReplacementNamed(context, RouteNames.mainLayout);
  }

  // Go to login screen
  static void goToLogin(BuildContext context) {
    Navigator.pushNamed(context, RouteNames.login);
  }

  // Go to signup screen
  static void goToSignup(BuildContext context) {
    Navigator.pushNamed(context, RouteNames.signup);
  }

  // Go to forgot password screen
  static void goToForgotPassword(BuildContext context) {
    Navigator.pushNamed(context, RouteNames.forgotPassword);
  }

  // Go to home screen (clear stack)
  static void goToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      RouteNames.home,
      (route) => false,
    );
  }

  // Go to category details with category name
  static void goToCategoryDetails(BuildContext context, String category) {
    Navigator.pushNamed(
      context,
      RouteNames.categoryDetails,
      arguments: category,
    );
  }

  // Go to collection details with title
  static void goToCollectionDetails(BuildContext context, String title) {
    Navigator.pushNamed(
      context,
      RouteNames.collectionDetails,
      arguments: title,
    );
  }

  // Go to product details with product data
  static void goToProductDetails(BuildContext context, dynamic product) {
    Navigator.pushNamed(context, RouteNames.productDetails, arguments: product);
  }

  // Go to cart screen
  static void goToCart(BuildContext context) {
    Navigator.pushNamed(context, RouteNames.cart);
  }

  // Go to checkout screen
  static void goToCheckout(BuildContext context) {
    Navigator.pushNamed(context, RouteNames.checkout);
  }

  // Go to profile screen
  static void goToProfile(BuildContext context) {
    Navigator.pushNamed(context, RouteNames.profile);
  }

  // Go to edit profile screen
  static void goToEditProfile(BuildContext context) {
    Navigator.pushNamed(context, RouteNames.editProfile);
  }

  // Go to try-on screen
  static void goToTryOn(BuildContext context) {
    Navigator.pushNamed(context, RouteNames.tryOn);
  }

  // Go to notifications screen
  static void goToNotifications(BuildContext context) {
    Navigator.pushNamed(context, RouteNames.notifications);
  }

  // Go back to previous screen
  static void goBack(BuildContext context) {
    Navigator.pop(context);
  }
}