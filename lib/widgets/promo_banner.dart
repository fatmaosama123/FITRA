// lib/widgets/promo_banner.dart

import 'dart:async';
import 'package:flutter/material.dart';

class PromoBanner extends StatefulWidget {
  const PromoBanner({super.key});

  @override
  State<PromoBanner> createState() => _PromoBannerState();
}

class _PromoBannerState extends State<PromoBanner> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  final List<PromoBannerModel> _promos = [
    PromoBannerModel(
      imageUrl: 'https://images.unsplash.com/photo-1556906781-9a412961c28c?w=800&q=80',
      title: 'Flash Sale',
      discount: '30% OFF',
      description: 'Limited time offer on all sneakers',
      accentColor: Color(0xFF2D2D2D),
    ),
    PromoBannerModel(
      imageUrl: 'https://images.unsplash.com/photo-1487222477894-8943e31ef7b2?w=800&q=80',
      title: 'Free Shipping',
      discount: 'WORLDWIDE',
      description: 'On orders over 150',
      accentColor: Color(0xFF8B5CF6),
    ),
    PromoBannerModel(
      imageUrl: 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=800&q=80',
      title: 'New Season',
      discount: 'DROP NOW',
      description: 'Autumn collection is here',
      accentColor: Color(0xFF059669),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_currentPage < _promos.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemCount: _promos.length,
              itemBuilder: (context, index) {
                return _buildPromoPage(_promos[index], isDark);
              },
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withOpacity(0.6),
                      Colors.black.withOpacity(0.85),
                    ],
                    stops: const [0.0, 0.4, 0.7, 1.0],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          child: Container(
                            key: ValueKey('tag_$_currentPage'),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _promos[_currentPage].accentColor,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              _promos[_currentPage].discount,
                              style: const TextStyle(
                                fontFamily: 'LabelFont',
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          child: Text(
                            _promos[_currentPage].title,
                            key: ValueKey('title_$_currentPage'),
                            style: const TextStyle(
                              fontFamily: 'HeadlineFont',
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          child: Text(
                            _promos[_currentPage].description,
                            key: ValueKey('desc_$_currentPage'),
                            style: TextStyle(
                              fontFamily: 'BodyFont',
                              fontSize: 13,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: Container(
                      key: ValueKey('btn_$_currentPage'),
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: _promos[_currentPage].accentColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 16,
              right: 20,
              child: Row(
                children: List.generate(_promos.length, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(left: 5),
                    width: _currentPage == index ? 20 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? Colors.white
                          : Colors.white.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromoPage(PromoBannerModel promo, bool isDark) {
    return Image.network(
      promo.imageUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: isDark ? Colors.grey[900] : Colors.grey[300],
          child: const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: promo.accentColor.withOpacity(0.2),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.local_offer_outlined,
                  size: 48,
                  color: promo.accentColor.withOpacity(0.6),
                ),
                const SizedBox(height: 8),
                Text(
                  promo.title,
                  style: TextStyle(
                    color: promo.accentColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class PromoBannerModel {
  final String imageUrl;
  final String title;
  final String discount;
  final String description;
  final Color accentColor;

  PromoBannerModel({
    required this.imageUrl,
    required this.title,
    required this.discount,
    required this.description,
    required this.accentColor,
  });
}