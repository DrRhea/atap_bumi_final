import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/equipment_provider.dart';
import '../../../models/equipment.dart';
import '../detail_product/detail_product_screen.dart';

class ProductScreen extends StatefulWidget {
  final int? categoryId;
  final int? subCategoryId;
  final String title;

  const ProductScreen({
    super.key,
    this.categoryId,
    this.subCategoryId,
    this.title = 'Equipment',
  });

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _sortBy = 'name';

  @override
  void initState() {
    super.initState();
    
    // Debug info
    print('ProductScreen initialized with:');
    print('- categoryId: ${widget.categoryId}');
    print('- subCategoryId: ${widget.subCategoryId}');
    print('- title: ${widget.title}');
    
    // Initialize animations
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeController.forward();
    _slideController.forward();
    
    // Load equipment data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadEquipments();
    });

    // Setup scroll listener for pagination
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadEquipments({bool refresh = true}) async {
    await Provider.of<EquipmentProvider>(context, listen: false).getEquipments(
      categoryId: widget.categoryId,
      subCategoryId: widget.subCategoryId,
      search: _searchController.text.isNotEmpty ? _searchController.text : null,
      sortBy: _sortBy,
      refresh: refresh,
    );
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      final provider = Provider.of<EquipmentProvider>(context, listen: false);
      if (provider.hasMoreData && !provider.isLoading) {
        _loadEquipments(refresh: false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              children: [
                _buildAppBar(context),
                _buildFilterInfo(),
                _buildSearchBar(),
                _buildSortOptions(),
                Expanded(child: _buildProductGrid()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        children: [
          // Back button
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFE2E8F0),
                width: 1,
              ),
            ),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Color(0xFF1E293B),
                size: 20,
              ),
              padding: const EdgeInsets.all(12),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Title
          Expanded(
            child: Text(
              widget.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E293B),
                fontFamily: 'Alexandria',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterInfo() {
    if (widget.categoryId == null && widget.subCategoryId == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF7CB342).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF7CB342).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.filter_list,
            size: 18,
            color: Color(0xFF7CB342),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              widget.subCategoryId != null 
                  ? 'Filtered by: ${widget.title}'
                  : 'Showing all equipment in ${widget.title}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF7CB342),
                fontFamily: 'Alexandria',
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              // Clear filters and show all equipment
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProductScreen(
                    title: 'All Equipment',
                  ),
                ),
              );
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'Clear',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF7CB342),
                fontFamily: 'Alexandria',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFE2E8F0),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            const Icon(
              Icons.search_outlined,
              color: Color(0xFF64748B),
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  // Debounce search
                  Future.delayed(const Duration(milliseconds: 500), () {
                    if (_searchController.text == value) {
                      _loadEquipments();
                    }
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Search equipment...',
                  hintStyle: TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Alexandria',
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                style: const TextStyle(
                  color: Color(0xFF1E293B),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Alexandria',
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF7CB342),
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                onPressed: _showFilterDialog,
                icon: const Icon(
                  Icons.tune,
                  color: Colors.white,
                  size: 18,
                ),
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(
                  minWidth: 32,
                  minHeight: 32,
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOptions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        height: 40,
        child: Row(
          children: [
            const Text(
              'Sort by:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF64748B),
                fontFamily: 'Alexandria',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _getSortOptions().length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final option = _getSortOptions()[index];
                  final isSelected = _sortBy == option['value'];
                  
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _sortBy = option['value']!;
                      });
                      _loadEquipments();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF7CB342) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? const Color(0xFF7CB342) : const Color(0xFFE2E8F0),
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        option['label']!,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : const Color(0xFF64748B),
                          fontFamily: 'Alexandria',
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductGrid() {
    return Consumer<EquipmentProvider>(
      builder: (context, equipmentProvider, child) {
        if (equipmentProvider.isLoading && equipmentProvider.equipments.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF7CB342),
              strokeWidth: 2.5,
            ),
          );
        }

        if (equipmentProvider.errorMessage != null && equipmentProvider.equipments.isEmpty) {
          return _buildErrorState(equipmentProvider);
        }

        if (equipmentProvider.equipments.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          onRefresh: () async {
            await _loadEquipments();
          },
          color: const Color(0xFF7CB342),
          child: GridView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8, // Increased from 0.75 to give more height
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: equipmentProvider.equipments.length + (equipmentProvider.hasMoreData ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == equipmentProvider.equipments.length) {
                // Loading indicator for pagination
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF7CB342),
                    strokeWidth: 2,
                  ),
                );
              }
              
              final equipment = equipmentProvider.equipments[index];
              return _buildProductCard(equipment);
            },
          ),
        );
      },
    );
  }

  Widget _buildErrorState(EquipmentProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFE53E3E).withValues(alpha: 0.2),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.wifi_off_outlined,
                size: 40,
                color: Color(0xFFE53E3E),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Unable to Load Equipment',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E293B),
                fontFamily: 'Alexandria',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              provider.errorMessage!,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF64748B),
                fontFamily: 'Alexandria',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF7CB342),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF7CB342).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _loadEquipments(),
                  borderRadius: BorderRadius.circular(12),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    child: Text(
                      'Try Again',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Alexandria',
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFE2E8F0),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.inventory_2_outlined,
                size: 60,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'No Equipment Found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E293B),
                fontFamily: 'Alexandria',
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Try adjusting your search or\nfilter criteria',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF64748B),
                fontFamily: 'Alexandria',
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(Equipment equipment) {
    return GestureDetector(
      onTap: () {
        // Navigate to equipment detail screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailProductScreen(equipment: equipment),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFE2E8F0),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Equipment image
            Expanded(
              flex: 4, // Increased from 3 to give more space for image
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: Stack(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: equipment.primaryPhotoUrl.isNotEmpty
                            ? Image.network(
                                equipment.primaryPhotoUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return _buildPlaceholderImage(equipment.equipmentName);
                                },
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                          : null,
                                      color: const Color(0xFF7CB342),
                                      strokeWidth: 2,
                                    ),
                                  );
                                },
                              )
                            : _buildPlaceholderImage(equipment.equipmentName),
                      ),
                      
                      // Availability indicator
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: equipment.isAvailable ? const Color(0xFF7CB342) : const Color(0xFFE53E3E),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: (equipment.isAvailable ? const Color(0xFF7CB342) : const Color(0xFFE53E3E)).withValues(alpha: 0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            equipment.isAvailable ? 'Available' : 'Out of Stock',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Alexandria',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Equipment details
            Expanded(
              flex: 3, // Increased from 2 to give more space for details
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Equipment name
                    Flexible(
                      child: Text(
                        equipment.equipmentName,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                          fontFamily: 'Alexandria',
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    
                    const SizedBox(height: 2),
                    
                    // Brand
                    if (equipment.brand != null)
                      Flexible(
                        child: Text(
                          equipment.brand!,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF64748B),
                            fontFamily: 'Alexandria',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    
                    const Spacer(),
                    
                    // Price and rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Rp ${equipment.rentalPricePerDay.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF7CB342),
                                  fontFamily: 'Alexandria',
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Text(
                                '/day',
                                style: TextStyle(
                                  fontSize: 9,
                                  color: Color(0xFF64748B),
                                  fontFamily: 'Alexandria',
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Rating
                        if (equipment.averageRating != null)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star,
                                size: 12,
                                color: Color(0xFFF59E0B),
                              ),
                              const SizedBox(width: 2),
                              Text(
                                equipment.averageRating!.toStringAsFixed(1),
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1E293B),
                                  fontFamily: 'Alexandria',
                                ),
                              ),
                            ],
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
    );
  }

  // Helper method untuk placeholder image
  Widget _buildPlaceholderImage(String name) {
    IconData icon;
    Color bgColor;

    if (name.toLowerCase().contains('tent')) {
      icon = Icons.home_outlined;
      bgColor = const Color(0xFF7CB342);
    } else if (name.toLowerCase().contains('bag') || name.toLowerCase().contains('backpack')) {
      icon = Icons.backpack_outlined;
      bgColor = const Color(0xFF3B82F6);
    } else if (name.toLowerCase().contains('shoe') || name.toLowerCase().contains('boot')) {
      icon = Icons.hiking;
      bgColor = const Color(0xFFF59E0B);
    } else if (name.toLowerCase().contains('jacket') || name.toLowerCase().contains('cloth')) {
      icon = Icons.checkroom_outlined;
      bgColor = const Color(0xFF8B5CF6);
    } else if (name.toLowerCase().contains('lamp') || name.toLowerCase().contains('light')) {
      icon = Icons.flashlight_on_outlined;
      bgColor = const Color(0xFFE53E3E);
    } else if (name.toLowerCase().contains('cook') || name.toLowerCase().contains('stove')) {
      icon = Icons.local_fire_department_outlined;
      bgColor = const Color(0xFFEF4444);
    } else {
      icon = Icons.outdoor_grill_outlined;
      bgColor = const Color(0xFF64748B);
    }

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            bgColor.withValues(alpha: 0.1),
            bgColor.withValues(alpha: 0.2),
          ],
        ),
      ),
      child: Icon(
        icon,
        size: 50,
        color: bgColor,
      ),
    );
  }

  // Helper methods
  List<Map<String, String>> _getSortOptions() {
    return [
      {'label': 'Name', 'value': 'name'},
      {'label': 'Price: Low to High', 'value': 'price_asc'},
      {'label': 'Price: High to Low', 'value': 'price_desc'},
      {'label': 'Rating', 'value': 'rating'},
    ];
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Header
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filter Equipment',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E293B),
                      fontFamily: 'Alexandria',
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _loadEquipments();
                    },
                    child: const Text(
                      'Apply',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF7CB342),
                        fontFamily: 'Alexandria',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Filter content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Coming soon...',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF64748B),
                        fontFamily: 'Alexandria',
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