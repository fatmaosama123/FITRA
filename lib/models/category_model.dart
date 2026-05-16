// lib/models/category_model.dart

import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String name;
  final String title;
  final String subtitle;
  final String description;
  final String imageUrl; // ← هنا رابط من النت
  final Color backgroundColor;
  final Color textColor;

  CategoryModel({
    required this.id,
    required this.name,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.imageUrl,
    required this.backgroundColor,
    required this.textColor,
  });

  static List<CategoryModel> get allCategories => [
    CategoryModel(
      id: '1',
      name: 'Streetwear',
      title: 'SAFE SAFER WORK',
      subtitle: 'Streetwear',
      description: 'Bold silhouettes for the urban landscape.',
      imageUrl:
          'https://images.unsplash.com/photo-1552374196-1ab2a1c593e8?w=600',
      backgroundColor: const Color(0xFF2E3B4E),
      textColor: Colors.white,
    ),
    CategoryModel(
      id: '2',
      name: 'Minimalist',
      title: '',
      subtitle: 'Minimalist',
      description: 'Quiet luxury and essential wardrobing.',
      imageUrl:
          'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?w=600',
      backgroundColor: const Color(0xFFE8E8E8),
      textColor: const Color(0xFF2E2E2E),
    ),
    CategoryModel(
      id: '3',
      name: 'Outerwear',
      title: '',
      subtitle: 'Outerwear',
      description: 'Statement pieces for every climate.',
      imageUrl:
          'https://images.unsplash.com/photo-1544022613-e87ca75a784a?w=600',
      backgroundColor: const Color(0xFF1A1A1A),
      textColor: Colors.white,
    ),
    CategoryModel(
      id: '4',
      name: 'Accessories',
      title: '',
      subtitle: 'Accessories',
      description: 'The final touch of curated detail.',
      imageUrl:
          'https://images.unsplash.com/photo-1523170335258-f5ed11844a49?w=600',
      backgroundColor: const Color(0xFF2E3B4E),
      textColor: Colors.white,
    ),
  ];

  static List<Map<String, String>> get seasonalEdits => [
    {'number': '01', 'title': 'Autumn Capsule \'24'},
    {'number': '02', 'title': 'Evening Atelier'},
    {'number': '03', 'title': 'Eco-Knit Series'},
  ];
}
