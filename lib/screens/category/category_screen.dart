import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/category_provider.dart';
import '../../models/category.dart';
import '../../widgets/bottom_navigation_bar.dart';
import '../category/product/product_screen.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    super.initState();
    // Load categories saat screen pertama kali dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryProvider>().getCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Category',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Alexandria',
          ),
        ),
      ),

      body: SafeArea(
        child: Consumer<CategoryProvider>(
          builder: (context, categoryProvider, child) {
            // Loading state
            if (categoryProvider.isLoading && categoryProvider.categories.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7CB342)),
                ),
              );
            }

            // Error state
            if (categoryProvider.errorMessage != null && categoryProvider.categories.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      categoryProvider.errorMessage!,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF64748B),
                        fontFamily: 'Alexandria',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        categoryProvider.clearError();
                        categoryProvider.getCategories();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7CB342),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text(
                        'Try Again',
                        style: TextStyle(fontFamily: 'Alexandria'),
                      ),
                    ),
                  ],
                ),
              );
            }

            // Main content
            return RefreshIndicator(
              onRefresh: () async {
                await categoryProvider.getCategories();
              },
              color: const Color(0xFF7CB342),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Search bar
                      _buildSearchBar(),
                      const SizedBox(height: 8),
                      
                      // Helper text
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F9FF),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFF7CB342).withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.info_outline,
                              size: 16,
                              color: Color(0xFF7CB342),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Tap category to expand subcategories. Use "View All" button to see all items.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[700],
                                  fontFamily: 'Alexandria',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Categories list
                      if (categoryProvider.categories.isNotEmpty)
                        ...categoryProvider.categories
                            .where((category) => category.isActive)
                            .map((category) => DynamicCategoryCard(
                                  category: category,
                                ))
                            .toList()
                      else
                        _buildEmptyState(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 1),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.search, 
            color: Color(0xFF64748B),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Gear',
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: Color(0xFF94A3B8),
                  fontFamily: 'Alexandria',
                ),
              ),
              style: TextStyle(
                fontFamily: 'Alexandria',
                color: Color(0xFF1E293B),
              ),
            ),
          ),
          
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.category_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          const Text(
            'No categories available',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF64748B),
              fontFamily: 'Alexandria',
            ),
          ),
        ],
      ),
    );
  }
}

class DynamicCategoryCard extends StatefulWidget {
  final EquipmentCategory category;

  const DynamicCategoryCard({
    super.key,
    required this.category,
  });

  @override
  State<DynamicCategoryCard> createState() => _DynamicCategoryCardState();
}

class _DynamicCategoryCardState extends State<DynamicCategoryCard> {
  List<EquipmentSubCategory> subCategories = [];
  bool isLoadingSubCategories = false;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    // Jika sudah ada subcategories dari API, gunakan itu
    if (widget.category.subCategories != null) {
      subCategories = widget.category.subCategories!;
    }
  }

  Future<void> _loadSubCategories() async {
    if (subCategories.isNotEmpty || isLoadingSubCategories) return;

    setState(() {
      isLoadingSubCategories = true;
    });

    try {
      final provider = context.read<CategoryProvider>();
      final loadedSubCategories = await provider.getSubCategories(widget.category.id);
      
      setState(() {
        subCategories = loadedSubCategories.where((sub) => sub.isActive).toList();
        isLoadingSubCategories = false;
      });
    } catch (e) {
      setState(() {
        isLoadingSubCategories = false;
      });
    }
  }

  void _toggleExpanded() {
    setState(() {
      isExpanded = !isExpanded;
    });
    
    if (isExpanded && subCategories.isEmpty) {
      _loadSubCategories();
    }
  }

  String _getCategoryIcon() {
    // ✅ Updated untuk menggunakan path assets/images/ yang sesuai pubspec.yaml
    final iconMap = {
      'tenda': 'assets/images/tenda1.png', // ✅ menggunakan tenda1.png lowercase
      'tent': 'assets/images/tenda1.png',
      'outdoor-apparel': 'assets/images/SHIRT.png', // ✅ menggunakan SHIRT.png uppercase
      'pakaian': 'assets/images/baju.png', // ✅ menggunakan baju.png lowercase
      'apparel': 'assets/images/SHIRT.png',
      'backpack-bags': 'assets/images/tas-ijo.png', // ✅ menggunakan tas-ijo.png lowercase
      'backpack': 'assets/images/SMALL.png', // ✅ menggunakan SMALL.png uppercase
      'bags': 'assets/images/tas-ijo.png',
      'sleeping-gear': 'assets/images/selimut.png', // ✅ menggunakan selimut.png lowercase
      'sleeping': 'assets/images/SLEEPBAG.png', // ✅ menggunakan SLEEPBAG.png uppercase
      'cooking-equipment': 'assets/images/kompor.png', // ✅ menggunakan kompor.png lowercase
      'cooking': 'assets/images/STOVE.png', // ✅ menggunakan STOVE.png uppercase
      'aksesoris': 'assets/images/lamp.png', // ✅ menggunakan lamp.png lowercase
      'accessories': 'assets/images/LAMP.png', // ✅ menggunakan LAMP.png uppercase
      'accessory': 'assets/images/LAMP.png',
    };

    final slug = widget.category.categorySlug.toLowerCase();
    return iconMap[slug] ?? 'assets/images/tenda1.png'; // Default fallback
  }

  String _getSubCategoryIcon(String subCategorySlug) {
    // ✅ Updated untuk menggunakan path assets/images/ yang sesuai pubspec.yaml
    final iconMap = {
      'single-layer-tent': 'assets/images/SINGLE.png', // ✅ uppercase
      'double-layer-tent': 'assets/images/DOUBLE.png', // ✅ uppercase
      'flysheet': 'assets/images/FLYSHEET.png', // ✅ uppercase
      'hat-cap': 'assets/images/HAT.png', // ✅ uppercase
      'outdoor-shirt': 'assets/images/SHIRT.png', // ✅ uppercase
      'jacket-outerwear': 'assets/images/JACKET.png', // ✅ uppercase
      'outdoor-pants': 'assets/images/PANTS.png', // ✅ uppercase
      'hiking-boots': 'assets/images/BOOTS.png', // ✅ uppercase
      'small-hiking-carrier': 'assets/images/SMALL.png', // ✅ uppercase
      'large-hiking-carrier': 'assets/images/LARGE.png', // ✅ uppercase
      'foam-mattress': 'assets/images/FOAM.png', // ✅ uppercase
      'sleeping-bag': 'assets/images/SLEEPBAG.png', // ✅ uppercase
      'air-mattress': 'assets/images/AIR.png', // ✅ uppercase
      'hammock': 'assets/images/HAMMOCK.png', // ✅ uppercase
      'nesting': 'assets/images/NESTING.png', // ✅ uppercase
      'camping-stove': 'assets/images/STOVE.png', // ✅ uppercase
      'eating-utensils': 'assets/images/UTENSIL.png', // ✅ uppercase
      'gas-fuel': 'assets/images/GAS.png', // ✅ uppercase
      'folding-table': 'assets/images/TABLE.png', // ✅ uppercase
      'folding-chair': 'assets/images/CHAIR.png', // ✅ uppercase
      'camping-light': 'assets/images/LAMP.png', // ✅ uppercase
      'handy-talkie': 'assets/images/WALKIE.png', // ✅ uppercase
    };

    final slug = subCategorySlug.toLowerCase();
    return iconMap[slug] ?? 'assets/images/tenda1.png'; // Default fallback
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E8),
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
      child: Column(
        children: [
          // Category header
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                // Simple tap to toggle expand/collapse
                _toggleExpanded();
              },
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // Category icon
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          _getCategoryIcon(), // ✅ Path sudah diperbaiki
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            print('Error loading category icon: ${_getCategoryIcon()}');
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.category,
                                color: Color(0xFF64748B),
                                size: 20,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.category.categoryName.toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              fontFamily: 'Alexandria',
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          if (widget.category.categoryDescription != null)
                            Text(
                              widget.category.categoryDescription!,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF64748B),
                                fontFamily: 'Alexandria',
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                    
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Navigate button (separate tap to go to products)
                        GestureDetector(
                          onTap: () {
                            // Navigate to product screen with category filter
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductScreen(
                                  categoryId: widget.category.id,
                                  title: widget.category.categoryName,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF7CB342).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFF7CB342).withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text(
                                  'View All',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF7CB342),
                                    fontFamily: 'Alexandria',
                                  ),
                                ),
                                SizedBox(width: 4),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 10,
                                  color: Color(0xFF7CB342),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '(${subCategories.length})',
                          style: const TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 14,
                            fontFamily: 'Alexandria',
                          ),
                        ),
                        const SizedBox(width: 8),
                        AnimatedRotation(
                          turns: isExpanded ? 0.25 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: const Icon(
                            Icons.chevron_right,
                            color: Color(0xFF7CB342),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Subcategories (expandable)
          if (isExpanded) ...[
            if (isLoadingSubCategories)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7CB342)),
                    ),
                  ),
                ),
              )
            else if (subCategories.isNotEmpty)
              ...subCategories.map((subCategory) => Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.white.withOpacity(0.7),
                      width: 1,
                    ),
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      // Add haptic feedback
                      // HapticFeedback.lightImpact(); // Uncomment if you want haptic feedback
                      
                      print('Navigating to subcategory: ${subCategory.subCategoryName}');
                      print('Category ID: ${widget.category.id}');
                      print('SubCategory ID: ${subCategory.id}');
                      
                      // Navigate to product screen with subcategory filter
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductScreen(
                            categoryId: widget.category.id,
                            subCategoryId: subCategory.id,
                            title: subCategory.subCategoryName,
                          ),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    splashColor: const Color(0xFF7CB342).withOpacity(0.1),
                    highlightColor: const Color(0xFF7CB342).withOpacity(0.05),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                _getSubCategoryIcon(subCategory.subCategorySlug), // ✅ Path sudah diperbaiki
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  print('Error loading subcategory icon: ${_getSubCategoryIcon(subCategory.subCategorySlug)}');
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.inventory_2_outlined,
                                      color: Color(0xFF64748B),
                                      size: 20,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  subCategory.subCategoryName,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Alexandria',
                                    color: Color(0xFF1E293B),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                if (subCategory.subCategoryDescription != null)
                                  Text(
                                    subCategory.subCategoryDescription!,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF94A3B8),
                                      fontFamily: 'Alexandria',
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right,
                            color: Color(0xFF7CB342),
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )).toList()
            else
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'No subcategories available',
                  style: TextStyle(
                    color: Color(0xFF94A3B8),
                    fontFamily: 'Alexandria',
                    fontSize: 14,
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
