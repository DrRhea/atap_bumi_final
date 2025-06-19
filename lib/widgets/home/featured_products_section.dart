import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/equipment_provider.dart';
import '../../models/equipment.dart';
import '../../screens/category/category_screen.dart';
import 'section_header.dart';
import 'product_card.dart';

class FeaturedProductsSection extends StatefulWidget {
  final double screenWidth;
  final int maxProducts;

  const FeaturedProductsSection({
    super.key,
    required this.screenWidth,
    this.maxProducts = 12,
  });

  @override
  State<FeaturedProductsSection> createState() => _FeaturedProductsSectionState();
}

class _FeaturedProductsSectionState extends State<FeaturedProductsSection> {
  @override
  void initState() {
    super.initState();
    // Load featured products when the widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EquipmentProvider>().getFeaturedEquipments(limit: widget.maxProducts);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EquipmentProvider>(
      builder: (context, equipmentProvider, child) {
        if (equipmentProvider.isLoading && equipmentProvider.equipments.isEmpty) {
          return _buildLoadingState();
        }

        if (equipmentProvider.errorMessage != null && equipmentProvider.equipments.isEmpty) {
          return _buildErrorState(equipmentProvider.errorMessage!);
        }

        final products = equipmentProvider.equipments;

        if (products.isEmpty) {
          return _buildEmptyState();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              title: 'Featured Products',
              actionText: 'View All',
              onActionPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CategoryScreen()),
                );
              },
              screenWidth: widget.screenWidth,
            ),
            SizedBox(height: widget.screenWidth * 0.04),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.68,
                crossAxisSpacing: widget.screenWidth * 0.03,
                mainAxisSpacing: widget.screenWidth * 0.03,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                try {
                  return ProductCard(
                    product: _equipmentToProductMap(products[index]),
                    screenWidth: widget.screenWidth,
                  );
                } catch (e) {
                  print('Error building product card: $e');
                  // Return a placeholder card in case of error
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.error_outline,
                        color: Colors.grey,
                        size: 32,
                      ),
                    ),
                  );
                }
              },
            ),

            if (products.length >= widget.maxProducts) ...[
              SizedBox(height: widget.screenWidth * 0.04),
              _buildViewMoreButton(),
            ],
          ],
        );
      },
    );
  }

  // Convert Equipment model to the format expected by ProductCard
  Map<String, dynamic> _equipmentToProductMap(Equipment equipment) {
    // Safe way to get primary photo URL
    String getImageUrl() {
      try {
        if (equipment.photos != null && equipment.photos!.isNotEmpty) {
          // Try to find primary photo
          final primaryPhotos = equipment.photos!.where((p) => p.isPrimary);
          if (primaryPhotos.isNotEmpty) {
            return primaryPhotos.first.photoUrl;
          }
          // If no primary photo, use first photo
          return equipment.photos!.first.photoUrl;
        }
        return 'assets/images/placeholder.jpg';
      } catch (e) {
        print('Error getting image URL: $e');
        return 'assets/images/placeholder.jpg';
      }
    }

    // Safe conversion to int for price
    int safeToInt(double value) {
      try {
        return value.round();
      } catch (e) {
        print('Error converting price to int: $e');
        return 0;
      }
    }

    // Safe category name extraction
    String getCategoryName() {
      try {
        return equipment.subCategory?.subCategoryName ?? 'Equipment';
      } catch (e) {
        print('Error getting category name: $e');
        return 'Equipment';
      }
    }

    return {
      'id': equipment.id,
      'name': equipment.equipmentName,
      'price': safeToInt(equipment.rentalPricePerDay),
      'originalPrice': null, // Equipment doesn't have original price
      'rating': equipment.averageRating ?? 0.0,
      'reviews': 0, // Equipment model doesn't have reviews count
      'image': getImageUrl(),
      'category': getCategoryName(),
      'discount': null, // No discount concept in Equipment model
      'isPopular': (equipment.averageRating ?? 0.0) >= 4.5,
    };
  }

  Widget _buildLoadingState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Featured Products',
          actionText: 'View All',
          onActionPressed: () {},
          screenWidth: widget.screenWidth,
        ),
        SizedBox(height: widget.screenWidth * 0.04),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.68,
            crossAxisSpacing: widget.screenWidth * 0.03,
            mainAxisSpacing: widget.screenWidth * 0.03,
          ),
          itemCount: 6, // Show 6 loading placeholders
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF7CB342),
                  strokeWidth: 2,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildErrorState(String errorMessage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Featured Products',
          actionText: 'View All',
          onActionPressed: () {},
          screenWidth: widget.screenWidth,
        ),
        SizedBox(height: widget.screenWidth * 0.04),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFFFEF2F2),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFE53E3E).withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: const Color(0xFFE53E3E),
              ),
              const SizedBox(height: 16),
              Text(
                'Failed to Load Products',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1E293B),
                  fontFamily: 'Alexandria',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                errorMessage,
                style: TextStyle(
                  fontSize: 14,
                  color: const Color(0xFF64748B),
                  fontFamily: 'Alexandria',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  context.read<EquipmentProvider>().getFeaturedEquipments(limit: widget.maxProducts);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7CB342),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Try Again',
                  style: TextStyle(
                    fontFamily: 'Alexandria',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Featured Products',
          actionText: 'View All',
          onActionPressed: () {},
          screenWidth: widget.screenWidth,
        ),
        SizedBox(height: widget.screenWidth * 0.04),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFE2E8F0),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                Icons.inventory_2_outlined,
                size: 64,
                color: const Color(0xFF64748B),
              ),
              const SizedBox(height: 16),
              Text(
                'No Products Available',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1E293B),
                  fontFamily: 'Alexandria',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Check back later for new products',
                style: TextStyle(
                  fontSize: 14,
                  color: const Color(0xFF64748B),
                  fontFamily: 'Alexandria',
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildViewMoreButton() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CategoryScreen()),
        );
      },
      child: Container(
        width: double.infinity,
        height: 48,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF7CB342), Color(0xFF8BC34A)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7CB342).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.grid_view_rounded,
                color: Colors.white,
                size: widget.screenWidth * 0.045,
              ),
              const SizedBox(width: 8),
              Text(
                'View All Products',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: widget.screenWidth * 0.038,
                  fontFamily: 'Alexandria',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}