import 'package:flutter/material.dart';
import 'package:atap_bumi_apps/screens/category/product/product_screen.dart';
import 'package:atap_bumi_apps/screens/category/rating_review/rating_review_screen.dart';
import '../../../models/rental.dart';

class OrderDetailsScreen extends StatelessWidget {
  final Rental? rental;
  
  const OrderDetailsScreen({super.key, this.rental});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Order Details",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1E293B),
            fontFamily: 'Alexandria',
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
        elevation: 0,
        titleSpacing: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Order Status Card
            Container(
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
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _getStatusColor().withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          _getStatusIcon(),
                          color: _getStatusColor(),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getStatusText(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: _getStatusColor(),
                                fontFamily: 'Alexandria',
                              ),
                            ),
                            Text(
                              _getStatusDescription(),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF64748B),
                                fontFamily: 'Alexandria',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (rental?.rentalStatus != null && rental!.rentalStatus.toLowerCase() == 'completed') ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDF4),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF7CB342).withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.local_shipping_outlined,
                            color: Color(0xFF7CB342),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Order has been returned',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF7CB342),
                                    fontFamily: 'Alexandria',
                                  ),
                                ),
                                const Text(
                                  '23-03-2005 16:19',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF64748B),
                                    fontFamily: 'Alexandria',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Shipping Address Card
            Container(
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
              padding: const EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.location_on_outlined,
                      color: Color(0xFF7CB342),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Delivery Address",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E293B),
                            fontFamily: 'Alexandria',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Nuansa Bening",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1E293B),
                            fontFamily: 'Alexandria',
                          ),
                        ),
                        const Text(
                          "(+62)812-3456-7890",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF64748B),
                            fontFamily: 'Alexandria',
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Jl. Melati No. 45, RT 04 / RW 03 Kel. Sukamaju, Kec. Cibinong Kab. Bogor, Jawa Barat 16913 Indonesia",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF64748B),
                            fontFamily: 'Alexandria',
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Products + Rent Summary
            Container(
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
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Order Items",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E293B),
                      fontFamily: 'Alexandria',
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (rental?.rentalDetails != null && rental!.rentalDetails!.isNotEmpty)
                    ..._buildProductListFromRental(rental!)
                  else
                    ..._buildProductList(),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFE2E8F0),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Rental Duration",
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF64748B),
                                fontFamily: 'Alexandria',
                              ),
                            ),
                            Text(
                              "${rental?.totalDays ?? 3} Days",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1E293B),
                                fontFamily: 'Alexandria',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total Items",
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF64748B),
                                fontFamily: 'Alexandria',
                              ),
                            ),
                            Text(
                              "${rental?.rentalDetails?.length ?? 3} Products",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1E293B),
                                fontFamily: 'Alexandria',
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 24, thickness: 1),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total Amount",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1E293B),
                                fontFamily: 'Alexandria',
                              ),
                            ),
                            Text(
                              "Rp${_formatPrice(rental?.totalAmount)}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF7CB342),
                                fontFamily: 'Alexandria',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Order Info
            Container(
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
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Order Information",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E293B),
                      fontFamily: 'Alexandria',
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow("Order Number", "#${rental?.id.toString() ?? "PDO078531"}"),
                  const SizedBox(height: 12),
                  _buildInfoRow("Payment Method", "Transfer Bank"),
                  const SizedBox(height: 12),
                  _buildInfoRow("Rental Start", rental?.rentalStartDate != null ? rental!.rentalStartDate.toString().substring(0, 10) : "2023-03-20"),
                  const SizedBox(height: 12),
                  _buildInfoRow("Rental End", rental?.rentalEndDate != null ? rental!.rentalEndDate.toString().substring(0, 10) : "2023-03-23"),
                  const SizedBox(height: 12),
                  _buildInfoRow("Status", _getStatusText()),
                ],
              ),
            ),

            const SizedBox(height: 24),
            // Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ProductScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFA2D7A2),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Rent Again",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Alexandria',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RatingReviewScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFA2D7A2), // Updated to match ReturnConfirmationScreen
                      foregroundColor: Colors.white, 
                      padding: const EdgeInsets.symmetric(vertical: 20), 
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15), // Updated border radius to 15
                      ),
                      elevation: 0, // Removed elevation
                    ),
                    child: const Text(
                      "Rate",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Alexandria', // Added font family
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildProductList() {
    final List<Map<String, dynamic>> items = [
      {"title": "EIGER CAYMAN LITE SHOES", "unit": "1 Unit", "price": 30000, "image": "assets/images/EIGER-BOOTS.png"},
      {"title": "TREKKING POLE HIGHTRACK 02 AREI OUTDOOGEAR", "unit": "1 Unit", "price": 15000, "image": "assets/images/TREKKING.png"},
      {"title": "EIGER STOVER 4P TENT", "unit": "1 Unit", "price": 85000, "image": "assets/images/EIGER-TENT.png"},
    ];

    return items.map((item) {
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                image: DecorationImage(
                  image: AssetImage(item['image']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(item['unit']),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      "Rp${item['price']?.toStringAsFixed(0)}",
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  // Build product list from actual rental data
  List<Widget> _buildProductListFromRental(Rental rental) {
    if (rental.rentalDetails == null || rental.rentalDetails!.isEmpty) {
      return _buildProductList(); // Fallback to hardcoded list
    }

    return rental.rentalDetails!.map((detail) {
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[300],
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    detail.equipment?.equipmentName ?? 'Unknown Equipment',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text("${detail.unitQuantity} Unit"),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      "Rp${_formatPrice(detail.rentalPricePerDay)}/day",
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  // Helper method to format price
  String _formatPrice(num? price) {
    if (price == null) return '0';
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), 
      (Match m) => '${m[1]}.'
    );
  }

  // Helper method to build info row
  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF64748B),
            fontFamily: 'Alexandria',
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
            fontFamily: 'Alexandria',
          ),
        ),
      ],
    );
  }

  // Helper method to get status color
  Color _getStatusColor() {
    final status = rental?.rentalStatus;
    if (status == null) return const Color(0xFF64748B);
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

  // Helper method to get status icon
  IconData _getStatusIcon() {
    final status = rental?.rentalStatus;
    if (status == null) return Icons.info_outline;
    switch (status.toLowerCase()) {
      case 'awaiting_payment':
        return Icons.payment_outlined;
      case 'processing':
        return Icons.hourglass_empty_outlined;
      case 'shipping':
        return Icons.local_shipping_outlined;
      case 'rented':
        return Icons.shopping_bag_outlined;
      case 'completed':
        return Icons.check_circle_outline;
      case 'cancelled':
        return Icons.cancel_outlined;
      default:
        return Icons.info_outline;
    }
  }

  // Helper method to get status text
  String _getStatusText() {
    final status = rental?.rentalStatus;
    if (status == null) return 'Unknown Status';
    switch (status.toLowerCase()) {
      case 'awaiting_payment':
        return 'Awaiting Payment';
      case 'processing':
        return 'Processing';
      case 'shipping':
        return 'Shipping';
      case 'rented':
        return 'Active Rental';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return 'Unknown Status';
    }
  }

  // Helper method to get status description
  String _getStatusDescription() {
    final status = rental?.rentalStatus;
    if (status == null) return 'Status information unavailable';
    switch (status.toLowerCase()) {
      case 'awaiting_payment':
        return 'Please complete your payment';
      case 'processing':
        return 'Your order is being processed';
      case 'shipping':
        return 'Your order is on the way';
      case 'rented':
        return 'Equipment is currently rented';
      case 'completed':
        return 'Order has been completed successfully';
      case 'cancelled':
        return 'Order has been cancelled';
      default:
        return 'Status information unavailable';
    }
  }
}