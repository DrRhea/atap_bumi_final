import 'package:flutter/material.dart';
import '../chat/chat_screen.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildTabBar(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                children: [
                  _buildNotificationItem(
                    title: 'Limited-Time Weekend Promo!',
                    message:
                        'Get ready for your next camping escape with our special weekend rental promo! Enjoy 10% off on tents, backpacks, stoves, and more when you rent between Friday and Sunday. Don\'t miss this chance — your gear for less, your adventure for more!',
                    icon: Icons.local_offer_rounded,
                    isHighlighted: true,
                    time: '2 hours ago',
                  ),
                  _buildNotificationItem(
                    title: 'Successful Return Confirmation',
                    message:
                        'Thank you for returning your camping gear! Everything was received in good condition. We appreciate your responsibility and hope to support your next outdoor adventure soon. Don\'t forget to check our latest promos for your future trips!',
                    icon: Icons.check_circle_outline_rounded,
                    time: '1 day ago',
                  ),
                  _buildNotificationItem(
                    title: 'Rental Period Ended',
                    message:
                        'Hi there! This is a friendly reminder that your rental period for the backpack has officially ended today. To avoid any late return charges, please make sure to return the item as soon as possible. If you need help or directions to the return point, just tap below!',
                    icon: Icons.access_time_rounded,
                    time: '2 days ago',
                  ),
                  _buildNotificationItem(
                    title: 'Upcoming Return Deadline',
                    message:
                        'Hello! Your tent and cooking gear rental is due tomorrow. We hope you had a great trip! To ensure a smooth return process and avoid penalties, kindly prepare the items for drop-off. Let us know if you need pickup service!',
                    icon: Icons.alarm_rounded,
                    time: '3 days ago',
                  ),
                  _buildNotificationItem(
                    title: 'Booking Confirmed',
                    message:
                        'Thanks for choosing our service! Your booking has been confirmed for May 10–12. All selected items will be prepared and ready for pickup/delivery.',
                    icon: Icons.calendar_today_rounded,
                    time: '1 week ago',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        children: [
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
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context, 
                '/home', 
                (route) => false,
              ),
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Color(0xFF1E293B),
                size: 20,
              ),
              padding: const EdgeInsets.all(12),
            ),
          ),
          
          const SizedBox(width: 16),
          
          const Text(
            'Notifications',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E293B),
              fontFamily: 'Alexandria',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
      child: Container(
        height: 48,
        padding: const EdgeInsets.all(4),
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
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChatScreen()),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Chat',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                      fontFamily: 'Alexandria',
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF7CB342),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7CB342).withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Notification',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontFamily: 'Alexandria',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem({
    required String title,
    required String message,
    required IconData icon,
    required String time,
    bool isHighlighted = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isHighlighted 
            ? const Color(0xFF7CB342).withValues(alpha: 0.05)
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isHighlighted 
              ? const Color(0xFF7CB342).withValues(alpha: 0.2)
              : const Color(0xFFE2E8F0),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isHighlighted 
                  ? const Color(0xFF7CB342) 
                  : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isHighlighted 
                    ? const Color(0xFF7CB342)
                    : const Color(0xFFE2E8F0),
                width: 1,
              ),
            ),
            child: Icon(
              icon, 
              size: 24, 
              color: isHighlighted 
                  ? Colors.white 
                  : const Color(0xFF64748B),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1E293B),
                          fontFamily: 'Alexandria',
                        ),
                      ),
                    ),
                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                        fontFamily: 'Alexandria',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF64748B),
                    fontFamily: 'Alexandria',
                    height: 1.5,
                  ),
                ),
                if (isHighlighted) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7CB342),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'View Promo',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontFamily: 'Alexandria',
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
