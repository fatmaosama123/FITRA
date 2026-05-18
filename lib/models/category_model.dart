// lib/models/category_model.dart

import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String name;
  final String title;
  final String subtitle;
  final String description;
  // List of images for carousel (was single imageUrl)
  final List<String> imageUrls;
  final Color backgroundColor;
  final Color textColor;

  CategoryModel({
    required this.id,
    required this.name,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.imageUrls,
    required this.backgroundColor,
    required this.textColor,
  });

  // All categories with multiple images
  static List<CategoryModel> get allCategories => [
        _cat('1', 'Streetwear', 'SAFE SAFER WORK', 'Streetwear',
            'Bold silhouettes for the urban landscape.',
            bg: const Color(0xFF2E3B4E), text: Colors.white,
            images: _streetwearImages),
        _cat('2', 'Minimalist', '', 'Minimalist',
            'Quiet luxury and essential wardrobing.',
            bg: const Color(0xFFE8E8E8), text: const Color(0xFF2E2E2E),
            images: _minimalistImages),
        _cat('3', 'Outerwear', '', 'Outerwear',
            'Statement pieces for every climate.',
            bg: const Color(0xFF1A1A1A), text: Colors.white,
            images: _outerwearImages),
        _cat('4', 'Accessories', '', 'Accessories',
            'The final touch of curated detail.',
            bg: const Color(0xFF2E3B4E), text: Colors.white,
            images: _accessoriesImages),
      ];

  // Helper to create category
  static CategoryModel _cat(
    String id,
    String name,
    String title,
    String subtitle,
    String description, {
    required Color bg,
    required Color text,
    required List<String> images,
  }) =>
      CategoryModel(
        id: id,
        name: name,
        title: title,
        subtitle: subtitle,
        description: description,
        imageUrls: images,
        backgroundColor: bg,
        textColor: text,
      );

  // Image collections for each category
  static final _streetwearImages = [
    'https://images.unsplash.com/photo-1552374196-1ab2a1c593e8?w=600',
    'https://images.unsplash.com/photo-1523398002811-999ca8dec234?w=600',
    'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=600',
    'https://images.unsplash.com/photo-1509631179647-0177331693ae?w=600',
  ];

  static final _minimalistImages = [
    'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?w=600',
    'https://images.unsplash.com/photo-1434389677669-e08b4cac3105?w=600',
    'https://images.unsplash.com/photo-1487222477894-8943e31ef7b2?w=600',
    'https://images.unsplash.com/photo-1445205170230-053b83016050?w=600',
  ];

  static final _outerwearImages = [
    'https://images.unsplash.com/photo-1544022613-e87ca75a784a?w=600',
    'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=600',
    'https://images.unsplash.com/photo-1487222477894-8943e31ef7b2?w=600',
    'https://images.unsplash.com/photo-1559582798-678dfc71ccd8?w=600',
  ];

  static final _accessoriesImages = [
    'https://images.unsplash.com/photo-1523170335258-f5ed11844a49?w=600',
    'https://images.unsplash.com/photo-1611085583191-a3b181a88401?w=600',
    'https://images.unsplash.com/photo-1576053139778-7e32f2ae3cfd?w=600',
    'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=600',
  ];

  // Seasonal collections
  static List<Map<String, String>> get seasonalEdits => [
        {'number': '01', 'title': 'Autumn Capsule \'24'},
        {'number': '02', 'title': 'Evening Atelier'},
        {'number': '03', 'title': 'Eco-Knit Series'},
      ];
}