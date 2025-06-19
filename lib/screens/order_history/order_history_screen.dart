import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/rental_provider.dart';
import '../../models/rental.dart';
import '../category/product/product_screen.dart';
import '../category/rating_review/rating_review_screen.dart';
import 'return_confirmation/return_confirmation_screen.dart';
import '../../widgets/bottom_navigation_bar.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: OrderPage(),
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 2), // Activity tab
    );
  }
}

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  String _selectedStatus = 'All';
  final List<String> _statusOptions = ['All', 'Reserved', 'Active', 'Returned', 'Cancelled'];

  @override
  void initState() {
    super.initState();
    
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
    
    // Load rentals when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RentalProvider>(context, listen: false).getRentals();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Text(
                    'My Orders',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E293B),
                      fontFamily: 'Alexandria',
                    ),
                  ),
                ),

                // Status Filter
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SizedBox(
                    height: 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _statusOptions.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final status = _statusOptions[index];
                        final isSelected = _selectedStatus == status;
                        
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedStatus = status;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFF7CB342) : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected ? const Color(0xFF7CB342) : const Color(0xFFE2E8F0),
                                width: 1.5,
                              ),
                              boxShadow: isSelected ? [
                                BoxShadow(
                                  color: const Color(0xFF7CB342).withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ] : null,
                            ),
                            child: Text(
                              status,
                              style: TextStyle(
                                fontSize: 14,
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
                ),

                const SizedBox(height: 24),

                // Orders List
                Expanded(
                  child: Consumer<RentalProvider>(
                    builder: (context, rentalProvider, child) {
                      if (rentalProvider.isLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF7CB342),
                            strokeWidth: 2.5,
                          ),
                        );
                      }

                      if (rentalProvider.errorMessage != null) {
                        return _buildErrorState(rentalProvider);
                      }

                      if (rentalProvider.rentals.isEmpty) {
                        return _buildEmptyState();
                      }

                      // Filter orders based on selected status
                      List<Rental> filteredOrders = _selectedStatus == 'All' 
                          ? rentalProvider.rentals
                          : rentalProvider.rentals.where((rental) => 
                              _getSimpleStatus(rental.rentalStatus).toLowerCase() == _selectedStatus.toLowerCase()
                            ).toList();

                      if (filteredOrders.isEmpty) {
                        return _buildNoOrdersForStatus();
                      }

                      return RefreshIndicator(
                        onRefresh: () async {
                          await rentalProvider.getRentals();
                        },
                        color: const Color(0xFF7CB342),
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          itemCount: filteredOrders.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            return OrderCard(rental: filteredOrders[index]);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to convert rental status to simple status
  String _getSimpleStatus(String rentalStatus) {
    switch (rentalStatus.toLowerCase()) {
      case 'awaiting_payment':
        return 'Reserved';
      case 'processing':
      case 'shipping':
        return 'Active';
      case 'rented':
        return 'Active';
      case 'completed':
        return 'Returned';
      case 'cancelled':
        return 'Cancelled';
      default:
        return 'Active';
    }
  }

  Widget _buildErrorState(RentalProvider rentalProvider) {
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
              'Unable to Load Orders',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E293B),
                fontFamily: 'Alexandria',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              rentalProvider.errorMessage!,
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
                  onTap: () => rentalProvider.getRentals(),
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
                Icons.receipt_long_outlined,
                size: 60,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'No Orders Yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E293B),
                fontFamily: 'Alexandria',
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Start exploring and rent some\ncamping equipment to see your orders here',
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

  Widget _buildNoOrdersForStatus() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFE2E8F0),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.filter_list_off,
                size: 50,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No $_selectedStatus Orders',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E293B),
                fontFamily: 'Alexandria',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You don\'t have any ${_selectedStatus.toLowerCase()} orders',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF64748B),
                fontFamily: 'Alexandria',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final Rental rental;

  const OrderCard({super.key, required this.rental});

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              '/order-details',
              arguments: rental,
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Order #${rental.id}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF64748B),
                        fontFamily: 'Alexandria',
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(rental.rentalStatus).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _getStatusColor(rental.rentalStatus).withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        _getSimpleStatus(rental.rentalStatus),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _getStatusColor(rental.rentalStatus),
                          fontFamily: 'Alexandria',
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Order items (from rentalDetails)
                if (rental.rentalDetails != null && rental.rentalDetails!.isNotEmpty) ...[
                  ...rental.rentalDetails!.take(2).map((detail) => _buildOrderItem(detail)),
                  if (rental.rentalDetails!.length > 2)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        '+${rental.rentalDetails!.length - 2} more items',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                          fontFamily: 'Alexandria',
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                ],

                const SizedBox(height: 16),

                // Total and actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                            fontFamily: 'Alexandria',
                          ),
                        ),
                        Text(
                          'Rp ${rental.totalAmount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E293B),
                            fontFamily: 'Alexandria',
                          ),
                        ),
                      ],
                    ),
                    
                    _buildActionButtons(context),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to convert rental status to simple status
  String _getSimpleStatus(String rentalStatus) {
    switch (rentalStatus.toLowerCase()) {
      case 'awaiting_payment':
        return 'Reserved';
      case 'processing':
      case 'shipping':
        return 'Active';
      case 'rented':
        return 'Active';
      case 'completed':
        return 'Returned';
      case 'cancelled':
        return 'Cancelled';
      default:
        return 'Active';
    }
  }

  Widget _buildOrderItem(RentalDetail detail) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          // Product image placeholder
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFFE2E8F0),
                width: 1,
              ),
            ),
            child: detail.equipment?.photos?.isNotEmpty == true
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      detail.equipment!.photos!.first.photoUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.image_not_supported_outlined,
                          color: Color(0xFF64748B),
                          size: 24,
                        );
                      },
                    ),
                  )
                : const Icon(
                    Icons.image_not_supported_outlined,
                    color: Color(0xFF64748B),
                    size: 24,
                  ),
          ),

          const SizedBox(width: 12),

          // Product details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  detail.equipment?.equipmentName ?? 'Unknown Equipment',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                    fontFamily: 'Alexandria',
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '${detail.unitQuantity} Unit',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                        fontFamily: 'Alexandria',
                      ),
                    ),
                    const Text(
                      ' • ',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    Text(
                      '${detail.totalDays} Days',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                        fontFamily: 'Alexandria',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Rp ${detail.rentalPricePerDay.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}/day',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF7CB342),
                    fontFamily: 'Alexandria',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final isReturned = rental.rentalStatus.toLowerCase() == 'completed';
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isReturned) ...[
          // Rent Again button
          Container(
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFFE2E8F0),
                width: 1.5,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProductScreen(),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(8),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'Rent Again',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                      fontFamily: 'Alexandria',
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Rate button
          Container(
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF7CB342),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF7CB342).withValues(alpha: 0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
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
                      builder: (context) => const RatingReviewScreen(),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(8),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'Rate',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontFamily: 'Alexandria',
                    ),
                  ),
                ),
              ),
            ),
          ),
        ] else ...[
          // Return button for active orders
          Container(
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF7CB342),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF7CB342).withValues(alpha: 0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
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
                      builder: (context) => const ReturnConfirmationScreen(),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(8),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'Return',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontFamily: 'Alexandria',
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'awaiting_payment':
        return const Color(0xFFF59E0B);
      case 'processing':
      case 'shipping':
      case 'rented':
        return const Color(0xFF3B82F6);
      case 'completed':
        return const Color(0xFF7CB342);
      case 'cancelled':
        return const Color(0xFFE53E3E);
      default:
        return const Color(0xFF64748B);
    }
  }
}