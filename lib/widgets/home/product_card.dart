import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final double screenWidth;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.screenWidth,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => print('Product selected: ${product['name']}'),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1.2,
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        image: DecorationImage(
                          image: AssetImage(product['image']),
                          fit: BoxFit.cover,
                          onError: (exception, stackTrace) {
                            print('Error loading product image: ${product['image']}');
                          },
                        ),
                      ),
                    ),

                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.1),
                          ],
                        ),
                      ),
                    ),

                    Positioned(
                      top: 8,
                      left: 8,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (product['discount'] != null)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.015,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE53E3E),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '-${product['discount']}%',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenWidth * 0.022,
                                  fontFamily: 'Alexandria',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                          if (product['isPopular'] == true)
                            Container(
                              margin: EdgeInsets.only(
                                left: product['discount'] != null ? 3 : 0,
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.015,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF7CB342),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'HOT',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenWidth * 0.02,
                                  fontFamily: 'Alexandria',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          Icons.favorite_border,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.025),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        product['category'],
                        style: TextStyle(
                          fontSize: screenWidth * 0.024,
                          color: const Color(0xFF7CB342),
                          fontFamily: 'Alexandria',
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 2),

                      Text(
                        product['name'],
                        style: TextStyle(
                          fontSize: screenWidth * 0.03,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Alexandria',
                          color: const Color(0xFF1E293B),
                          height: 1.15,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 4),

                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star,
                            size: screenWidth * 0.028,
                            color: const Color(0xFFFFC107),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${product['rating']}',
                            style: TextStyle(
                              fontSize: screenWidth * 0.026,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Alexandria',
                              color: const Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '(${product['reviews']})',
                            style: TextStyle(
                              fontSize: screenWidth * 0.023,
                              fontFamily: 'Alexandria',
                              color: const Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Rp${_formatPrice(product['price'])}',
                            style: TextStyle(
                              fontSize: screenWidth * 0.03,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Alexandria',
                              color: const Color(0xFF1E293B),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (product['originalPrice'] != null)
                            Text(
                              'Rp${_formatPrice(product['originalPrice'])}',
                              style: TextStyle(
                                fontSize: screenWidth * 0.024,
                                fontFamily: 'Alexandria',
                                color: const Color(0xFF94A3B8),
                                decoration: TextDecoration.lineThrough,
                                height: 1.2,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }
}