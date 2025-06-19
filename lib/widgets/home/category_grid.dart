import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../screens/category/product/product_screen.dart';

class CategoryGrid extends StatelessWidget {
  final double screenWidth;

  const CategoryGrid({
    super.key,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    final categories = [
      {
        'label': 'Tent',
        'icon': 'assets/icon/TENDA.svg',
        'color': const Color(0xFFE8F5E8),
        'categoryId': 1, // Tent category
      },
      {
        'label': 'Sleeping Gear',
        'icon': 'assets/icon/TIDUR.svg',
        'color': const Color(0xFFF3E5F5),
        'categoryId': 4, // Sleeping Gear category
      },
      {
        'label': 'Backpack',
        'icon': 'assets/icon/TAS.svg',
        'color': const Color(0xFFE3F2FD),
        'categoryId': 3, // Backpacks category
      },
      {
        'label': 'Cooking Gear',
        'icon': 'assets/icon/MASAK.svg',
        'color': const Color(0xFFFFF3E0),
        'categoryId': 5, // Cooking Gear category
      },
      {
        'label': 'Outdoor Apparel',
        'icon': 'assets/icon/PAKAIAN.svg',
        'color': const Color(0xFFFCE4EC),
        'categoryId': 2, // Outdoor Apparel category
      },
      {
        'label': 'Accessories',
        'icon': 'assets/icon/AKSESORIS.svg',
        'color': const Color(0xFFE0F2F1),
        'categoryId': 6, // Accessories category
      },
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      childAspectRatio: 0.9,
      crossAxisSpacing: screenWidth * 0.03,
      mainAxisSpacing: screenWidth * 0.03,
      children: categories.map((category) {
        return _buildCategoryItem(
          context,
          label: category['label']! as String,
          iconPath: category['icon']! as String,
          color: category['color']! as Color,
          categoryId: category['categoryId']! as int,
        );
      }).toList(),
    );
  }

  Widget _buildCategoryItem(
    BuildContext context, {
    required String label,
    required String iconPath,
    required Color color,
    required int categoryId,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductScreen(
              categoryId: categoryId,
              title: label,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductScreen(
                    categoryId: categoryId,
                    title: label,
                  ),
                ),
              );
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.03),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: screenWidth * 0.15,
                    height: screenWidth * 0.15,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        iconPath,
                        width: screenWidth * 0.08,
                        height: screenWidth * 0.08,
                        placeholderBuilder: (context) => Icon(
                          Icons.category,
                          size: screenWidth * 0.08,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.02),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: screenWidth * 0.032,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Alexandria',
                      color: const Color(0xFF1E293B),
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}