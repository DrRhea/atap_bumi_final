import 'package:flutter/material.dart';

class RatingReviewScreen extends StatefulWidget {
  const RatingReviewScreen({super.key});

  @override
  State<RatingReviewScreen> createState() => _RatingReviewScreenState();
}

class _RatingReviewScreenState extends State<RatingReviewScreen> {
  int _rating = 4; // Default to 4 stars

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Back button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context); // Back functionality
                },
              ),
            ),

            // Product image and title
            Column(
              children: [
                SizedBox(
                  width: 159,
                  height: 159,
                  child: Image.asset(
                    "assets/images/BOOTS.png",
                    fit: BoxFit.contain, // Ensure image fits without stretching
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Shoes Eiger Air Man',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),

            // White rounded container
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Rate your experience text
                    const Text(
                      'Rate your experience with our rental gear!',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    // Star Rating
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: List.generate(
                          5,
                          (index) => GestureDetector(
                            onTap: () {
                              setState(() {
                                _rating = index + 1;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: Icon(
                                Icons.star_rounded,
                                size: 40,
                                color: index < _rating
                                    ? const Color(0xFFFF6000)
                                    : Colors.grey.shade300,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Add Photo section
                    const Text(
                      'Add Photo',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Photo buttons
                    Row(
                      children: [
                        // Camera button
                        Stack(
                          children: [
                            Container(
                              width: 45,
                              height: 41,
                              decoration: BoxDecoration(
                                color: const Color(0xCC6A6D6A),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                              ),
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                width: 11,
                                height: 11,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF6FAE6F),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 8,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(width: 12),

                        // Add photo button 1
                        Container(
                          width: 45,
                          height: 41,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.add),
                        ),

                        const SizedBox(width: 12),

                        // Add photo button 2
                        Container(
                          width: 45,
                          height: 41,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.add),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Comment section
                    const Text(
                      'Comment',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Comment text field
                    Container(
                      height: 116,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Type text here',
                            style: TextStyle(
                              color: Color(0xCC6A6C6A),
                              fontSize: 13,
                              fontFamily: 'Alata',
                            ),
                          ),
                        ),
                      ),
                    ),

                    const Spacer(),

                    // Submit button
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: ElevatedButton(
                        onPressed: () {
                          // Submit review functionality
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFA2D7A2),
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Submit Review',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}