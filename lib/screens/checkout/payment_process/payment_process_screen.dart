import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../payment_confirmation/payment_confirmation_screen.dart';
import '../../../services/rental_service.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/rental_provider.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/services/storage_service.dart';
import '../../../models/cart.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;

class PaymentProcessScreen extends StatefulWidget {
  final double? total;
  final String? paymentMethod;
  final String? shippingMethod;
  final String? deliveryOption;
  final String? messageForAdmin;
  final List<CartItem>? cartItems;

  const PaymentProcessScreen({
    Key? key,
    this.total,
    this.paymentMethod,
    this.shippingMethod,
    this.deliveryOption,
    this.messageForAdmin,
    this.cartItems,
  }) : super(key: key);

  @override
  State<PaymentProcessScreen> createState() => _PaymentProcessScreenState();
}

class _PaymentProcessScreenState extends State<PaymentProcessScreen> with TickerProviderStateMixin {
  late Timer _timer;
  int _secondsRemaining = 23 * 3600 + 59 * 60 + 59; // 23 hours, 59 minutes, 59 seconds

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;

  // Payment proof upload variables
  File? _proofOfPaymentImage;
  Uint8List? _proofOfPaymentBytes;
  final ImagePicker _picker = ImagePicker();
  bool _isUploadingProof = false;

  @override
  void initState() {
    super.initState();
    _startTimer();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
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
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _fadeController.forward();
    _slideController.forward();
    _pulseController.repeat(reverse: true);
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer.cancel();
        }
      });
    });
  }

  String _formatTime() {
    int hours = _secondsRemaining ~/ 3600;
    int minutes = (_secondsRemaining % 3600) ~/ 60;
    int seconds = _secondsRemaining % 60;
    return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    String message = "Account number copied!";
    if (text.contains("1234567890")) {
      message = "Bank account number copied!";
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Text(
              message,
              style: const TextStyle(
                fontFamily: 'Alexandria',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // Image picker methods for payment proof
  Future<void> _pickImageFromGallery() async {
    try {
      setState(() {
        _isUploadingProof = true;
      });

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _proofOfPaymentImage = File(image.path);
        _proofOfPaymentBytes = bytes;
        _isUploadingProof = false;
      });


        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                const Text(
                  'Payment proof uploaded successfully!',
                  style: TextStyle(
                    fontFamily: 'Alexandria',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF10B981),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      } else {
        setState(() {
          _isUploadingProof = false;
        });
      }
    } catch (e) {
      setState(() {
        _isUploadingProof = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.white),
              const SizedBox(width: 12),
              const Text(
                'Failed to upload image. Please try again.',
                style: TextStyle(
                  fontFamily: 'Alexandria',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Upload Payment Proof',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Alexandria',
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Color(0xFF6366F1)),
                title: const Text(
                  'Choose from Gallery',
                  style: TextStyle(fontFamily: 'Alexandria'),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromGallery();
                },
              ),
              
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  bool get _isPaymentProofUploaded => _proofOfPaymentImage != null;

  @override
  void dispose() {
    _timer.cancel();
    _fadeController.dispose();
    _slideController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  String _formatRupiah(double amount) {
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match match) => '${match[1]}.',
    )}';
  }

  String _getBackendPaymentMethod(String paymentMethod) {
    switch (paymentMethod.toLowerCase()) {
      case 'cash on delivery':
        return 'cash';
      case 'transfer bank':
        return 'bank_transfer';
      case 'e-wallet':
        return 'e_wallet';
      case 'debit/credit card':
        return 'credit_card';
      default:
        return 'bank_transfer';
    }
  }

  Widget _buildPaymentMethodSection() {
    final paymentMethod = widget.paymentMethod ?? 'Transfer Bank';

    Map<String, Map<String, dynamic>> paymentInfo = {
      "Cash On Delivery": {
        "title": "Cash Payment",
        "icon": Icons.money,
        "color": const Color(0xFF10B981),
        "content": _buildCashOnDeliveryContent(),
      },
      "Transfer Bank": {
        "title": "Bank Transfer",
        "icon": Icons.account_balance,
        "color": const Color(0xFF3B82F6),
        "content": _buildBankTransferContent(),
      },
      "E-Wallet": {
        "title": "E-Wallet Payment",
        "icon": Icons.account_balance_wallet,
        "color": const Color(0xFF8B5CF6),
        "content": _buildEWalletContent(),
      },
      "Debit/Credit Card": {
        "title": "Card Payment",
        "icon": Icons.credit_card,
        "color": const Color(0xFFF59E0B),
        "content": _buildCardPaymentContent(),
      },
    };

    final info = paymentInfo[paymentMethod] ?? paymentInfo["Transfer Bank"]!;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
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
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: (info["color"] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  info["icon"] as IconData,
                  color: info["color"] as Color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                info["title"] as String,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                  fontFamily: 'Alexandria',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          info["content"] as Widget,
        ],
      ),
    );
  }

  Widget _buildCashOnDeliveryContent() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF10B981).withOpacity(0.1),
            const Color(0xFF059669).withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF10B981).withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF10B981).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.delivery_dining,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Pay on Delivery",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E293B),
                        fontFamily: 'Alexandria',
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Pay with cash when your order arrives",
                      style: TextStyle(
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
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Instructions:",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                    fontFamily: 'Alexandria',
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "• Prepare exact amount in cash\n• Show this payment confirmation to delivery person\n• Payment will be collected upon delivery",
                  style: TextStyle(
                    fontSize: 13,
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
    );
  }

  Widget _buildBankTransferContent() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF3B82F6).withOpacity(0.1),
            const Color(0xFF1E40AF).withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF3B82F6).withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Bank Account Details",
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF64748B),
              fontFamily: 'Alexandria',
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF3B82F6).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "BCA",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF64748B),
                          fontFamily: 'Alexandria',
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "1234567890",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1E293B),
                          fontFamily: 'Alexandria',
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Atap Bumi Camping",
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF64748B),
                          fontFamily: 'Alexandria',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ScaleTransition(
                scale: _pulseAnimation,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF3B82F6).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    onTap: () => _copyToClipboard("1234567890"),
                    child: const Icon(
                      Icons.copy,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: Color(0xFF10B981),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Transfer exactly ${_formatRupiah(widget.total ?? 0)} and upload proof of payment",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF10B981),
                      fontFamily: 'Alexandria',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEWalletContent() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF8B5CF6).withOpacity(0.1),
            const Color(0xFF7C3AED).withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF8B5CF6).withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF8B5CF6).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.qr_code,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Scan QR Code",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E293B),
                        fontFamily: 'Alexandria',
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Use GoPay, OVO, DANA, or other e-wallets",
                      style: TextStyle(
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
          const SizedBox(height: 16),
          Center(
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF8B5CF6).withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.qr_code_scanner,
                      size: 48,
                      color: Color(0xFF8B5CF6),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "QR Code",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF64748B),
                        fontFamily: 'Alexandria',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardPaymentContent() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFF59E0B).withOpacity(0.1),
            const Color(0xFFD97706).withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFF59E0B).withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFF59E0B).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.payment,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Secure Card Payment",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E293B),
                        fontFamily: 'Alexandria',
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Visa, Mastercard, and other major cards accepted",
                      style: TextStyle(
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
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Payment Features:",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                    fontFamily: 'Alexandria',
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "• 3D Secure verification\n• SSL encrypted transactions\n• Instant payment processing",
                  style: TextStyle(
                    fontSize: 13,
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
    );
  }

  Widget _buildPaymentInstructions() {
    final paymentMethod = widget.paymentMethod ?? 'Transfer Bank';

    switch (paymentMethod) {
      case "Cash On Delivery":
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ModernInstructionStep(
              number: 1,
              text: "Wait for our delivery person to arrive at your location",
              color: const Color(0xFF10B981),
            ),
            const SizedBox(height: 16),
            ModernInstructionStep(
              number: 2,
              text: "Check your order and make sure everything is correct",
              color: const Color(0xFF3B82F6),
            ),
            const SizedBox(height: 16),
            ModernInstructionStep(
              number: 3,
              text: "Pay the exact amount in cash to the delivery person",
              color: const Color(0xFF8B5CF6),
            ),
          ],
        );

      case "E-Wallet":
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ModernInstructionStep(
              number: 1,
              text: "Open your e-wallet app (GoPay, OVO, DANA, etc.)",
              color: const Color(0xFF10B981),
            ),
            const SizedBox(height: 16),
            ModernInstructionStep(
              number: 2,
              text: "Scan the QR code above using your e-wallet app",
              color: const Color(0xFF3B82F6),
            ),
            const SizedBox(height: 16),
            ModernInstructionStep(
              number: 3,
              text: "Confirm the payment amount and complete the transaction",
              color: const Color(0xFF8B5CF6),
            ),
          ],
        );

      case "Debit/Credit Card":
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ModernInstructionStep(
              number: 1,
              text: "Click 'I've Paid' button to proceed to card payment gateway",
              color: const Color(0xFF10B981),
            ),
            const SizedBox(height: 16),
            ModernInstructionStep(
              number: 2,
              text: "Enter your card details (number, expiry, CVV) securely",
              color: const Color(0xFF3B82F6),
            ),
            const SizedBox(height: 16),
            ModernInstructionStep(
              number: 3,
              text: "Complete 3D Secure verification and confirm payment",
              color: const Color(0xFF8B5CF6),
            ),
          ],
        );

      default: // Transfer Bank
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ModernInstructionStep(
              number: 1,
              text: "Login to your mobile banking or internet banking",
              color: const Color(0xFF10B981),
            ),
            const SizedBox(height: 16),
            ModernInstructionStep(
              number: 2,
              text: "Transfer to BCA account 1234567890 (Atap Bumi Camping)",
              color: const Color(0xFF3B82F6),
            ),
            const SizedBox(height: 16),
            ModernInstructionStep(
              number: 3,
              text: "Transfer exactly ${_formatRupiah(widget.total ?? 0)} and click 'I've Paid'",
              color: const Color(0xFF8B5CF6),
            ),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7CB342), Color(0xFF8BC34A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF7CB342).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.payment,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Payment Process',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E293B),
                    fontFamily: 'Alexandria',
                  ),
                ),
                Text(
                  'Complete your transfer',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF64748B),
                    fontFamily: 'Alexandria',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Payment Summary Card
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
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
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.account_balance_wallet,
                              color: Color(0xFF10B981),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Payment Summary',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1E293B),
                              fontFamily: 'Alexandria',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF10B981).withOpacity(0.1),
                              const Color(0xFF059669).withOpacity(0.05),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFF10B981).withOpacity(0.2),
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Total Payment",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF64748B),
                                    fontFamily: 'Alexandria',
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF10B981), Color(0xFF059669)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF10B981).withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    widget.total != null
                                        ? _formatRupiah(widget.total!)
                                        : "Rp 0",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                      fontFamily: 'Alexandria',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Container(
                              height: 1,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    const Color(0xFF10B981).withOpacity(0.3),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEF4444).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.access_time,
                                    color: Color(0xFFEF4444),
                                    size: 16,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  "Payment expires in",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF64748B),
                                    fontFamily: 'Alexandria',
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEF4444).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: const Color(0xFFEF4444).withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    _formatTime(),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFFEF4444),
                                      fontFamily: 'Alexandria',
                                    ),
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
                const SizedBox(height: 20),
                // Payment Method Card - Dynamic based on selected method
                _buildPaymentMethodSection(),
                const SizedBox(height: 20),
                // Instructions Card
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF59E0B).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.list_alt,
                              color: Color(0xFFF59E0B),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Payment Instructions',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1E293B),
                              fontFamily: 'Alexandria',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildPaymentInstructions(),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Bukti pembayaran section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF7CB342).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.upload_file,
                              color: Color(0xFF7CB342),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Upload Bukti Pembayaran',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1E293B),
                              fontFamily: 'Alexandria',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (_proofOfPaymentImage != null || _proofOfPaymentBytes != null)
                        Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: kIsWeb
                                  ? (_proofOfPaymentBytes != null
                                      ? Image.memory(
                                          _proofOfPaymentBytes!,
                                          width: double.infinity,
                                          height: 180,
                                          fit: BoxFit.cover,
                                        )
                                      : const SizedBox.shrink())
                                  : (_proofOfPaymentImage != null
                                      ? Image.file(
                                          _proofOfPaymentImage!,
                                          width: double.infinity,
                                          height: 180,
                                          fit: BoxFit.cover,
                                        )
                                      : const SizedBox.shrink()),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: _showImagePickerOptions,
                                    icon: const Icon(Icons.edit, color: Color(0xFF7CB342)),
                                    label: const Text(
                                      "Ganti Bukti",
                                      style: TextStyle(
                                        color: Color(0xFF7CB342),
                                        fontFamily: 'Alexandria',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFF1F5F9),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      else
                        ElevatedButton.icon(
                          onPressed: _isUploadingProof ? null : _showImagePickerOptions,
                          icon: const Icon(Icons.upload_file, color: Color(0xFF7CB342)),
                          label: Text(
                            _isUploadingProof ? "Mengunggah..." : "Upload Bukti Pembayaran",
                            style: const TextStyle(
                              color: Color(0xFF7CB342),
                              fontFamily: 'Alexandria',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF1F5F9),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 34),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFF94A3B8),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF94A3B8).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 18,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Alexandria',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: _isPaymentProofUploaded
                        ? [const Color(0xFF7CB342), const Color(0xFF8BC34A)]
                        : [Colors.grey.shade400, Colors.grey.shade500],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: _isPaymentProofUploaded
                      ? [
                          BoxShadow(
                            color: const Color(0xFF7CB342).withOpacity(0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                            spreadRadius: 0,
                          ),
                        ]
                      : [],
                ),
                child: ElevatedButton(
                  onPressed: !_isPaymentProofUploaded
                      ? null
                      : () async {
                          try {
                            final cartProvider = Provider.of<CartProvider>(context, listen: false);
                            final rentalProvider = Provider.of<RentalProvider>(context, listen: false);

                            final itemsToProcess = widget.cartItems ?? cartProvider.selectedItems;

                            if (itemsToProcess.isEmpty) {
                              throw Exception('No cart items to process');
                            }

                            // Step 1: Sync cart items to backend first
                            List<int> cartItemIds = [];

                            for (var item in itemsToProcess) {
                              try {
                                final success = await cartProvider.addToCart(
                                  equipmentStockId: item.equipmentId,
                                  unitQuantity: item.quantity,
                                  plannedStartDate: DateTime.now().add(const Duration(days: 1)),
                                  plannedEndDate: DateTime.now().add(const Duration(days: 8)),
                                  notes: 'Added from checkout',
                                );

                                if (success) {
                                  await cartProvider.getCartItems();
                                  final backendItems = cartProvider.cartItems;

                                  final matchingItem = backendItems.where((backendItem) =>
                                      backendItem.equipmentId == item.equipmentId &&
                                      backendItem.quantity == item.quantity).firstOrNull;

                                  if (matchingItem != null) {
                                    cartItemIds.add(int.parse(matchingItem.id));
                                  }
                                }
                              } catch (e) {}
                            }

                            if (cartItemIds.isEmpty) {
                              throw Exception('Failed to sync cart items to backend');
                            }

                            // Step 2: Create rental with cart item IDs
                            final rentalData = {
                              'shipping_address_id': 1,
                              'rental_start_date': DateTime.now().add(const Duration(days: 1)).toIso8601String().split('T')[0],
                              'rental_end_date': DateTime.now().add(const Duration(days: 8)).toIso8601String().split('T')[0],
                              'shipping_method': (widget.shippingMethod ?? 'delivery').toLowerCase(),
                              'rental_notes': widget.messageForAdmin ?? '',
                              'cart_item_ids': cartItemIds,
                            };

                            bool rentalSuccess = false;
                            int? rentalId;

                            try {
                              rentalSuccess = await rentalProvider.createRental(rentalData);

                              if (rentalSuccess && rentalProvider.selectedRental != null) {
                                rentalId = rentalProvider.selectedRental!.id;
                              } else {
                                throw Exception('Failed to create rental: ${rentalProvider.errorMessage}');
                              }
                            } catch (e) {
                              throw e;
                            }

                            // Step 3: Create payment entry
                            try {
                              final paymentData = {
                                'rental_id': rentalId,
                                'payment_method': _getBackendPaymentMethod(widget.paymentMethod ?? 'Transfer Bank'),
                              };

                              final response = await http.post(
                                Uri.parse('${ApiConstants.baseUrl}/payments'),
                                headers: {
                                  'Content-Type': 'application/json',
                                  'Accept': 'application/json',
                                  if (await StorageService.getAccessToken() != null)
                                    'Authorization': 'Bearer ${await StorageService.getAccessToken()}',
                                },
                                body: jsonEncode(paymentData),
                              );
                            } catch (e) {}

                            // Step 4: Save to local storage as backup
                            try {
                              final cartItemsData = cartProvider.selectedItems.map((item) => {
                                    'equipment_stock_id': int.tryParse(item.equipmentId) ?? 1,
                                    'unit_quantity': item.quantity,
                                    'equipment_id': int.tryParse(item.equipmentId) ?? 1,
                                    'equipment_name': item.equipmentName,
                                    'price_per_day': item.pricePerDay,
                                    'image_url': item.imageUrl,
                                  }).toList();

                              await RentalService.saveRental(
                                totalAmount: widget.total ?? 0,
                                paymentMethod: widget.paymentMethod ?? 'Transfer Bank',
                                shippingMethod: widget.shippingMethod ?? 'Delivery',
                                deliveryOption: widget.deliveryOption,
                                messageForAdmin: widget.messageForAdmin,
                                cartItems: cartItemsData,
                              );
                            } catch (e) {}

                            if (rentalSuccess && context.mounted) {
                              await cartProvider.clearCart();

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Rental created successfully! Rental ID: $rentalId'),
                                  backgroundColor: Colors.green,
                                ),
                              );

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PaymentConfirmationScreen(),
                                ),
                              );
                            } else if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Failed to process payment: ${rentalProvider.errorMessage ?? "Unknown error"}'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error processing payment: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _isPaymentProofUploaded ? Icons.check_circle : Icons.upload_file,
                        color: _isPaymentProofUploaded ? Colors.white : Colors.grey.shade600,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isPaymentProofUploaded ? "I've Paid" : "Upload Proof First",
                        style: TextStyle(
                          color: _isPaymentProofUploaded ? Colors.white : Colors.grey.shade600,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Alexandria',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ModernInstructionStep extends StatelessWidget {
  final int number;
  final String text;
  final Color color;

  const ModernInstructionStep({
    Key? key,
    required this.number,
    required this.text,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, color.withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              number.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14,
                fontFamily: 'Alexandria',
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF64748B),
                fontFamily: 'Alexandria',
                height: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}