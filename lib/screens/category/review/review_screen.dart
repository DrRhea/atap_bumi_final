import 'package:flutter/material.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildRatingSection(),
            Expanded(child: _buildReviewsList()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const Icon(Icons.arrow_back, size: 24),
          const SizedBox(width: 16),
          Text(
            'Reviews',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFDFEDDF),
        borderRadius: BorderRadius.circular(1.5),
        border: Border.all(width: 0.5, color: const Color(0xFFD2CCCC)),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              _buildRatingStars(),
              const SizedBox(width: 10),
              Expanded(child: _buildFilterButtons()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRatingStars() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: '4,5',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextSpan(
                text: '  dari 15',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(
            5,
            (index) =>
                const Icon(Icons.star, color: Color(0xFFFF6000), size: 22),
          ),
        ),

      ],
    );
  }

  Widget _buildFilterButtons() {
    return Column(
      children: [
        Row(
          children: [
            _buildFilterButton('Semua', isSelected: true, width: 68),
            const SizedBox(width: 12),
            _buildFilterButton('5 Bintang (10)', width: 104),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildFilterButton('4 Bintang (3)', width: 97),
            const SizedBox(width: 5),
            _buildFilterButton('3 Bintang (2)', width: 97),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildFilterButton('2 Bintang (0)', width: 97),
            const SizedBox(width: 5),
            _buildFilterButton('1 Bintang (0)', width: 97),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterButton(
    String text, {
    bool isSelected = false,
    required double width,
  }) {
    return Container(
      width: width,
      height: 21,
      decoration: BoxDecoration(
        color: const Color(0xFFEFF5EF),
        border: Border.all(
          width: 0.5,
          color: isSelected ? const Color(0xFF6FAE6F) : const Color(0xFF5A5A5A),
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildReviewsList() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: [
          _buildReviewItem(
            name: 'Julian Dwi Satrio',
            date: 'April 30, 2025',
            rating: 5,
            comment:
                'Excellent quality! The hiking boots were super comfortable and kept my feet dry the entire trip. Will definitely rent again!',
          ),
          const Divider(height: 30),
          _buildReviewItem(
            name: 'Meisya Amalia',
            date: 'April 24, 2025',
            rating: 4,
            comment:
                'The boots were sturdy and reliable on rough terrain. Slightly tight at first, but they broke in quickly. Great rental!',
          ),
          const Divider(height: 30),
          _buildReviewItem(
            name: 'Rexy Putra',
            date: 'April 22, 2025',
            rating: 4,
            comment:
                'Great boots overall! They were durable and handled muddy trails well. Just wished they were a bit more breathable.',
          ),
          const Divider(height: 30),
          _buildReviewItem(
            name: 'Izzuddin Azzam',
            date: 'March 28, 2025',
            rating: 3,
            comment:
                'The boots worked fine but didn\'t feel very fresh. Still usable for short hikes, but not the most comfortable option.',
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem({
    required String name,
    required String date,
    required int rating,
    required String comment,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    date,
                    style: const TextStyle(
                      color: Color(0xFF5A5A5A),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    Icons.star,
                    color:
                        index < rating
                            ? const Color(0xFFFF6000)
                            : Colors.grey[300],
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            comment,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
