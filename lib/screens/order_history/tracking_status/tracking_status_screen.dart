import 'package:flutter/material.dart';

class TrackingStatusScreen extends StatelessWidget {
  const TrackingStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Shipment in Progress",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        backgroundColor: Colors.green[300],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Map
            Container(
              margin: const EdgeInsets.all(16),
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[300],
                image: const DecorationImage(
                  image: AssetImage('assets/images/MAPS.jpg'), // Custom map image
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Estimated arrival and progress
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Estimated arrival on March 23rd",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  // Progress bar
                  Row(
                    children: [
                      const Icon(Icons.circle, size: 12, color: Colors.green),
                      const Expanded(
                        child: Divider(
                          thickness: 2,
                          color: Colors.green,
                        ),
                      ),
                      const Icon(Icons.check_circle,
                          size: 20, color: Colors.green),
                      const Expanded(
                        child: Divider(
                          thickness: 2,
                          color: Colors.green,
                        ),
                      ),
                      const Icon(Icons.circle_outlined,
                          size: 12, color: Colors.green),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Progress labels
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Package Picked Up",
                        style: TextStyle(fontSize: 12),
                      ),
                      Text(
                        "En Route to Your Address",
                        style: TextStyle(fontSize: 12),
                      ),
                      Text(
                        "Order Delivered",
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Detailed tracking information
                  const Text(
                    "Delivery Details:",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Origin: Camping Gear Rental Warehouse, Jakarta",
                    style: TextStyle(fontSize: 12),
                  ),
                  const Text(
                    "Current Location: On transit to Bandung (May 4th, 2025, 10:30 AM)",
                    style: TextStyle(fontSize: 12),
                  ),
                  const Text(
                    "Destination: Your Address, Bandung",
                    style: TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Status: Your camping gear (Tent, Sleeping Bag, Cooking Set) is en route and expected to arrive by March 23rd, 2025.",
                    style: TextStyle(fontSize: 12),
                  ),
                  const Text(
                    "Courier: FastCamp Delivery Service",
                    style: TextStyle(fontSize: 12),
                  ),
                  const Text(
                    "Tracking ID: TRK-2025-045678",
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}