import 'package:flutter/material.dart';

class ArticlesTipsScreen extends StatelessWidget {
  const ArticlesTipsScreen({super.key});

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Ini mencegah scroll otomatis yang bikin overflow
      body: SafeArea(
        bottom: true,
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
            // App bar with back button
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 4.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, size: 24),
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      // Handle back navigation
                    },
                  ),
                ],
              ),
            ),
            
            // Content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 40.0),
                children: [
                  // Title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      'Tent Setup for Beginners',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Alexandria',
                        color: Colors.black,
                        height: 1.2,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Video placeholder with background image
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/tent_article.webp'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Play button
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.play_arrow_rounded,
                              size: 30,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                  
                  const SizedBox(height: 20),
                  
                  // Article text
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      'Are you new to camping and feeling unsure about how to pitch a tent? Don\'t worry — you\'re not alone! This article is your step-by-step guide to setting up a tent easily and correctly, even if you\'ve never done it before. Learn how to pick the right spot, unpack and sort your gear, and assemble your tent confidently. With clear instructions and helpful tips, you\'ll feel like a pro in no time.\n\nWhether you\'re planning a weekend getaway in the wild or an overnight stay at a campsite, getting your shelter up smoothly is the first step to an unforgettable adventure.',
                      style: TextStyle(
                        fontSize: 14,
                        color: const Color(0xFF5A5A5A),
                        height: 1.5,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Tips section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD0E7D0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tips',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Alexandria',
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildTipItem('Practice setting up your tent at home to be more prepared for your trip.'),
                          _buildTipItem('Choose a flat, slightly elevated spot to avoid water pooling.'),
                          _buildTipItem('Use a groundsheet to keep the tent dry and protect it from damage.'),
                          _buildTipItem('Stake at a 45° angle away from the tent for better stability.'),
                          _buildTipItem('Tighten the guy lines to keep the tent stable in any weather.'),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
  
  Widget _buildTipItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', 
            style: TextStyle(
              color: Color(0xFF5A5A5A), 
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFF5A5A5A),
                fontSize: 12,
                height: 1.4,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}