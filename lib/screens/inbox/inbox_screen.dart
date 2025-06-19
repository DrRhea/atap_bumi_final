import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../core/services/chat_service.dart';

class InboxScreen extends StatefulWidget {
  final int initialTabIndex;

  const InboxScreen({
    super.key,
    this.initialTabIndex = 0, // 0 = Chat, 1 = Notifications
  });

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _messageController = TextEditingController();
  
  List<Map<String, dynamic>> chats = [];
  Map<String, dynamic>? selectedChat;
  List<Map<String, dynamic>> messages = [];
  bool isLoading = true;
  bool isSending = false;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );

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
    
    // Load chats
    _loadChats();
  }

  Future<void> _loadChats() async {
    try {
      setState(() {
        isLoading = true;
      });

      print('Loading chats...'); // Debug log
      final response = await ChatService.getChats();
      print('Chat response: $response'); // Debug log
      
      if (response['success'] == true) {
        final data = response['data'];
        List<Map<String, dynamic>> chatList = [];
        
        // Handle different response structures
        if (data is Map && data.containsKey('data')) {
          // If response has nested 'data' key
          chatList = List<Map<String, dynamic>>.from(data['data'] ?? []);
        } else if (data is List) {
          // If response 'data' is directly a list
          chatList = List<Map<String, dynamic>>.from(data);
        } else if (data is Map && data.containsKey('chats')) {
          // If response has 'chats' key
          chatList = List<Map<String, dynamic>>.from(data['chats'] ?? []);
        }
        
        print('Parsed chats: $chatList'); // Debug log
        
        setState(() {
          chats = chatList;
          isLoading = false;
        });
      } else {
        print('Failed to load chats: ${response['message']}'); // Debug log
        setState(() {
          isLoading = false;
        });
        
        // Show error message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['message'] ?? 'Failed to load chats')),
          );
        }
      }
    } catch (e) {
      print('Error loading chats: $e'); // Debug log
      setState(() {
        isLoading = false;
      });
      
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading chats: $e')),
        );
      }
    }
  }

  Future<void> _loadChatMessages(int chatId) async {
    try {
      print('Loading messages for chat $chatId...'); // Debug log
      final response = await ChatService.getChatMessages(chatId);
      print('Messages response: $response'); // Debug log
      
      if (response['success'] == true) {
        final data = response['data'];
        List<Map<String, dynamic>> messageList = [];
        
        // Handle different response structures
        if (data is Map && data.containsKey('messages')) {
          messageList = List<Map<String, dynamic>>.from(data['messages'] ?? []);
        } else if (data is List) {
          messageList = List<Map<String, dynamic>>.from(data);
        }
        
        print('Parsed messages: $messageList'); // Debug log
        
        setState(() {
          messages = messageList;
        });
      } else {
        print('Failed to load messages: ${response['message']}'); // Debug log
      }
    } catch (e) {
      print('Error loading messages: $e'); // Debug log
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _messageController.dispose();
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
              children: [
                // Header with back button
                Padding(
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
                          onPressed: () {
                            // Navigate directly to home screen
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              AppRoutes.home,
                              (route) => false,
                            );
                          },
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
                        'Inbox',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1E293B),
                          fontFamily: 'Alexandria',
                        ),
                      ),
                    ],
                  ),
                ),

                // Custom Tab Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFE2E8F0),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF7CB342), Color(0xFF8BC34A)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF7CB342).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      labelColor: Colors.white,
                      unselectedLabelColor: const Color(0xFF64748B),
                      labelStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Alexandria',
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Alexandria',
                      ),
                      tabs: const [
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.chat_bubble_outline, size: 18),
                              SizedBox(width: 8),
                              Text('Chat'),
                            ],
                          ),
                        ),
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.notifications_none, size: 18),
                              SizedBox(width: 8),
                              Text('Notifications'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Tab Content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildChatTab(),
                      _buildNotificationTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChatTab() {
    if (selectedChat == null) {
      return _buildChatList();
    } else {
      return _buildChatDetail();
    }
  }

  Widget _buildChatList() {
    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading chats...'),
          ],
        ),
      );
    }

    if (chats.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No chats yet',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start a conversation with support',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _showNewChatDialog,
              icon: const Icon(Icons.add),
              label: const Text('New Chat'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Add refresh button
            TextButton.icon(
              onPressed: _loadChats,
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Add new chat button and refresh button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _showNewChatDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('New Chat'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: _loadChats,
                icon: const Icon(Icons.refresh),
                tooltip: 'Refresh',
              ),
            ],
          ),
        ),
        
        // Chat list
        Expanded(
          child: RefreshIndicator(
            onRefresh: _loadChats,
            child: ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];
                return _buildChatItem(chat);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChatItem(Map<String, dynamic> chat) {
    final latestMessage = chat['messages']?.isNotEmpty == true ? chat['messages'][0] : null;
    final status = chat['status'] ?? 'open';
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF6366F1),
          child: Text(
            (chat['subject'] ?? 'S').toString().substring(0, 1).toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          chat['subject'] ?? 'Support Chat',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (latestMessage != null)
              Text(
                latestMessage['message'] ?? '',
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            const SizedBox(height: 4),
            Text(
              _getStatusText(status),
              style: TextStyle(
                color: _getStatusColor(status),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              _formatDate(chat['created_at']),
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: _getStatusColor(status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                status.toUpperCase(),
                style: TextStyle(
                  color: _getStatusColor(status),
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        onTap: () => _openChatDetail(chat),
      ),
    );
  }

  Widget _buildChatDetail() {
    return Column(
      children: [
        // Chat header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    selectedChat = null;
                    messages.clear();
                  });
                },
                icon: const Icon(Icons.arrow_back),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedChat!['subject'] ?? 'Support Chat',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      _getStatusText(selectedChat!['status']),
                      style: TextStyle(
                        color: _getStatusColor(selectedChat!['status']),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        // Messages area
        Expanded(
          child: messages.isEmpty
              ? const Center(
                  child: Text(
                    'No messages yet',
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 16,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return _buildChatMessage(
                      message: message['message'] ?? '',
                      isFromSupport: message['is_admin_reply'] == true,
                      time: _formatMessageTime(message['created_at']),
                    );
                  },
                ),
        ),

        // Message input area
        _buildMessageInput(),
      ],
    );
  }

  Widget _buildMessageInput() {
    return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(
                color: const Color(0xFFE2E8F0),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFE2E8F0),
                      width: 1.5,
                    ),
                  ),
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                      hintStyle: TextStyle(
                        color: Color(0xFF94A3B8),
                        fontFamily: 'Alexandria',
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                    ),
                    style: const TextStyle(
                      fontFamily: 'Alexandria',
                      color: Color(0xFF1E293B),
                    ),
                    maxLines: 3,
                    minLines: 1,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 48,
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
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _sendMessage,
                    borderRadius: BorderRadius.circular(16),
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
  }

  Widget _buildChatMessage({
    required String message,
    required bool isFromSupport,
    required String time,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            isFromSupport ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (isFromSupport) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFF10B981),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.support_agent,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isFromSupport
                    ? Colors.white
                    : const Color(0xFF6366F1),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isFromSupport ? 4 : 16),
                  bottomRight: Radius.circular(isFromSupport ? 16 : 4),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 14,
                      color: isFromSupport ? const Color(0xFF1E293B) : Colors.white,
                      fontFamily: 'Alexandria',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 12,
                      color: isFromSupport ? const Color(0xFF94A3B8) : Colors.white70,
                      fontFamily: 'Alexandria',
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!isFromSupport) ...[
            const SizedBox(width: 12),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFF64748B),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 18,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNotificationTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      children: [
        _buildNotificationItem(
          title: 'Limited-Time Weekend Promo!',
          message:
              'Get ready for your next camping escape with our special weekend rental promo! Enjoy 10% off on tents, backpacks, stoves, and more when you rent between Friday and Sunday.',
          icon: Icons.local_offer_rounded,
          isHighlighted: true,
          time: '2 hours ago',
        ),
        _buildNotificationItem(
          title: 'Successful Return Confirmation',
          message:
              'Thank you for returning your camping gear! Everything was received in good condition. We appreciate your responsibility and hope to support your next outdoor adventure soon.',
          icon: Icons.check_circle_outline_rounded,
          time: '1 day ago',
        ),
        _buildNotificationItem(
          title: 'Rental Period Ended',
          message:
              'Hi there! This is a friendly reminder that your rental period for the backpack has officially ended today. To avoid any late return charges, please make sure to return the item as soon as possible.',
          icon: Icons.access_time_rounded,
          time: '2 days ago',
        ),
        _buildNotificationItem(
          title: 'Upcoming Return Deadline',
          message:
              'Hello! Your tent and cooking gear rental is due tomorrow. We hope you had a great trip! To ensure a smooth return process and avoid penalties, kindly prepare the items for drop-off.',
          icon: Icons.alarm_rounded,
          time: '3 days ago',
        ),
        _buildNotificationItem(
          title: 'Booking Confirmed',
          message:
              'Great news! Your rental booking has been confirmed. Your camping equipment will be ready for pickup tomorrow at 9:00 AM. Don\'t forget to bring your ID!',
          icon: Icons.event_available_rounded,
          time: '5 days ago',
        ),
      ],
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
            ? const Color(0xFFF0F9FF) 
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isHighlighted 
              ? const Color(0xFF7CB342).withOpacity(0.3)
              : const Color(0xFFE2E8F0),
          width: isHighlighted ? 2 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isHighlighted
                ? const Color(0xFF7CB342).withOpacity(0.1)
                : Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
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
              color: isHighlighted 
                  ? Colors.white 
                  : const Color(0xFF64748B),
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isHighlighted 
                              ? const Color(0xFF7CB342) 
                              : const Color(0xFF1E293B),
                          fontFamily: 'Alexandria',
                        ),
                      ),
                    ),
                    if (isHighlighted)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF7CB342),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'NEW',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Alexandria',
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF64748B),
                    fontFamily: 'Alexandria',
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF94A3B8),
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

  String _getStatusText(String? status) {
    switch (status) {
      case 'open':
        return 'Open - Waiting for response';
      case 'closed':
        return 'Closed';
      case 'in_progress':
        return 'In Progress';
      default:
        return 'Open';
    }
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'open':
        return Colors.green;
      case 'closed':
        return Colors.grey;
      case 'in_progress':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return '';
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);
      
      if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return '';
    }
  }

  String _formatMessageTime(String? dateString) {
    if (dateString == null) return '';
    try {
      final date = DateTime.parse(dateString);
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return '';
    }
  }

  void _openChatDetail(Map<String, dynamic> chat) {
    setState(() {
      selectedChat = chat;
    });
    _loadChatMessages(chat['id']);
  }

  void _showNewChatDialog() {
    final subjectController = TextEditingController();
    final messageController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Chat'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: subjectController,
              decoration: const InputDecoration(
                labelText: 'Subject',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: messageController,
              decoration: const InputDecoration(
                labelText: 'Message',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (subjectController.text.isNotEmpty &&
                  messageController.text.isNotEmpty) {
                Navigator.pop(context);
                await _createNewChat(
                  subjectController.text,
                  messageController.text,
                );
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  Future<void> _createNewChat(String subject, String message) async {
    try {
      final response = await ChatService.createChat(
        subject: subject,
        message: message,
      );
      if (response['success'] == true) {
        _loadChats(); // Refresh chat list
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Chat created successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? 'Failed to create chat')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating chat: $e')),
      );
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty || selectedChat == null || isSending) {
      return;
    }

    setState(() {
      isSending = true;
    });

    try {
      final response = await ChatService.sendMessage(
        selectedChat!['id'],
        _messageController.text.trim(),
      );

      if (response['success'] == true) {
        _messageController.clear();
        _loadChatMessages(selectedChat!['id']); // Refresh messages
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? 'Failed to send message')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending message: $e')),
      );
    } finally {
      setState(() {
        isSending = false;
      });
    }
  }
}
