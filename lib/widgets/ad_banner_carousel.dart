// lib/widgets/ad_banner_carousel.dart

import 'dart:async';
import 'package:flutter/material.dart';

// A carousel widget that shows ads with auto-play
class AdBannerCarousel extends StatefulWidget {
  const AdBannerCarousel({super.key});

  @override
  State<AdBannerCarousel> createState() => _AdBannerCarouselState();
}

class _AdBannerCarouselState extends State<AdBannerCarousel> {
  // Controls the page swiping
  final PageController _pageController = PageController();
  // Tracks which ad is showing now
  int _currentPage = 0;
  // Timer for auto-play
  Timer? _timer;

  // List of all ads to show
  final List<AdBannerModel> _ads = [
    AdBannerModel(
      imageUrl: 'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=800&q=80',
      title: 'Summer Collection',
      subtitle: 'Up to 50% OFF',
      ctaText: 'Shop Now',
      bgColor: Color(0xFFFF6B6B),
    ),
    AdBannerModel(
      imageUrl: 'https://images.unsplash.com/photo-1445205170230-053b83016050?w=800&q=80',
      title: 'New Arrivals',
      subtitle: 'Fresh styles daily',
      ctaText: 'Explore',
      bgColor: Color(0xFF4ECDC4),
    ),
    AdBannerModel(
      imageUrl: 'https://images.unsplash.com/photo-1469334031218-e382a71b716b?w=800&q=80',
      title: 'Premium Denim',
      subtitle: 'Handcrafted quality',
      ctaText: 'View Collection',
      bgColor: Color(0xFF45B7D1),
    ),
    AdBannerModel(
      imageUrl: 'https://images.unsplash.com/photo-1558171813-4c088753af8f?w=800&q=80',
      title: 'Accessories',
      subtitle: 'Complete your look',
      ctaText: 'Discover',
      bgColor: Color(0xFF96CEB4),
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Start auto-play when widget loads
    _startAutoPlay();
  }

  // Auto-play: move to next ad every 5 seconds
  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      // Go to next page, or back to first if at end
      if (_currentPage < _ads.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      // Animate to the new page
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
    // Clean up: stop timer and dispose controller
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Check if dark mode is on
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // Main card container
        Container(
          height: 180,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              // Shadow under the card
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              children: [
                // Swipeable pages
                PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    // Update current page when swiped
                    setState(() => _currentPage = index);
                  },
                  itemCount: _ads.length,
                  itemBuilder: (context, index) {
                    return _buildAdPage(_ads[index], isDark);
                  },
                ),
                // Dark gradient overlay for text readability
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.black.withOpacity(0.3),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ),
                // Ad text content (left side)
                Positioned(
                  left: 24,
                  top: 32,
                  bottom: 32,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Ad title with animation
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        child: Text(
                          _ads[_currentPage].title,
                          key: ValueKey(_currentPage),
                          style: const TextStyle(
                            fontFamily: 'HeadlineFont',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Ad subtitle with animation
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        child: Text(
                          _ads[_currentPage].subtitle,
                          key: ValueKey('sub_$_currentPage'),
                          style: TextStyle(
                            fontFamily: 'BodyFont',
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Call-to-action button with animation
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        child: Container(
                          key: ValueKey('cta_$_currentPage'),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: _ads[_currentPage].bgColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _ads[_currentPage].ctaText,
                            style: const TextStyle(
                              fontFamily: 'LabelFont',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Page indicator dots (bottom right)
                Positioned(
                  bottom: 16,
                  right: 24,
                  child: Row(
                    children: List.generate(_ads.length, (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(left: 6),
                        // Active dot is wider
                        width: _currentPage == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? Colors.white
                              : Colors.white.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Builds one ad page with image
  Widget _buildAdPage(AdBannerModel ad, bool isDark) {
    return Image.network(
      ad.imageUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      // Show loader while image loads
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: isDark ? Colors.grey[900] : Colors.grey[200],
          child: const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          ),
        );
      },
      // Show fallback if image fails to load
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: ad.bgColor.withOpacity(0.3),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_not_supported,
                  size: 48,
                  color: Colors.white.withOpacity(0.6),
                ),
                const SizedBox(height: 8),
                Text(
                  ad.title,
                  style: const TextStyle(
                    color: Colors.white,
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

// Data model for one ad
class AdBannerModel {
  final String imageUrl;
  final String title;
  final String subtitle;
  final String ctaText;
  final Color bgColor;

  AdBannerModel({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.ctaText,
    required this.bgColor,
  });
}