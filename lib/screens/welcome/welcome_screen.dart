import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../routes/app_routes.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _buttonController;
  
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _buttonAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controllers
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Initialize animations
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _buttonAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _buttonController,
      curve: Curves.elasticOut,
    ));

    // Start animations with delays
    Future.delayed(const Duration(milliseconds: 300), () {
      _fadeController.forward();
    });
    
    Future.delayed(const Duration(milliseconds: 600), () {
      _slideController.forward();
    });
    
    Future.delayed(const Duration(milliseconds: 1200), () {
      _buttonController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8FFFE),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            // Decorative background elements
            _buildBackgroundDecorations(),
            
            // Main content
            SafeArea(
              child: Column(
                children: [
                  // Logo section
                  Expanded(
                    flex: 3,
                    child: _buildLogoSection(),
                  ),
                  
                  // Content section
                  Expanded(
                    flex: 4,
                    child: _buildContentSection(screenWidth),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundDecorations() {
    return Stack(
      children: [
        // Top right decoration
        Positioned(
          top: -80,
          right: -80,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF7CB342).withOpacity(0.08),
            ),
          ),
        ),
        
        // Bottom left decoration
        Positioned(
          bottom: -120,
          left: -120,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFA2D7A2).withOpacity(0.12),
            ),
          ),
        ),
        
        // Middle right small circle
        Positioned(
          top: 200,
          right: 30,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF7CB342).withOpacity(0.06),
            ),
          ),
        ),
        
        // Floating dots with animation
        Positioned(
          top: 120,
          left: 60,
          child: _buildFloatingDot(8, const Color(0xFF7CB342).withOpacity(0.4)),
        ),
        Positioned(
          top: 350,
          right: 100,
          child: _buildFloatingDot(12, const Color(0xFFA2D7A2).withOpacity(0.5)),
        ),
        Positioned(
          bottom: 350,
          left: 100,
          child: _buildFloatingDot(6, const Color(0xFF7CB342).withOpacity(0.3)),
        ),
      ],
    );
  }

  Widget _buildFloatingDot(double size, Color color) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 3000 + (size * 100).toInt()),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, -15 * value),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLogoSection() {
    return Center(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo with enhanced shadow - SMALLER LOGO, SAME CONTAINER
            Container(
              width: 180,  // ✅ Keep container size same
              height: 180, // ✅ Keep container size same
              padding: const EdgeInsets.all(20), // ✅ Keep padding same
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF7CB342).withOpacity(0.15),
                    blurRadius: 25,
                    spreadRadius: 5,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                    spreadRadius: 0,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: SvgPicture.asset(
                'assets/icon/LOGO-1.svg',
                height: 90,  // ✅ Reduced from 120 to 90
                width: 90,   // ✅ Reduced from 120 to 90
                fit: BoxFit.contain,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Brand name with better styling
            FadeTransition(
              opacity: _fadeAnimation,
              child: const Text(
                'Atap Bumi',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2D5016),
                  fontFamily: 'Alexandria',
                  letterSpacing: 1.5,
                ),
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Subtitle
            FadeTransition(
              opacity: _fadeAnimation,
              child: const Text(
                'Camping Equipment Rental',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF64748B),
                  fontFamily: 'Alexandria',
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentSection(double screenWidth) {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF7CB342),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7CB342).withOpacity(0.3),
              offset: const Offset(0, -4),
              blurRadius: 20,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background pattern
            Positioned(
              top: -20,
              right: -20,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
            ),
            Positioned(
              bottom: -30,
              left: -30,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),
            
            // Main content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome text with better styling
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: const Text(
                      'Welcome!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Alexandria',
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Description text with better readability
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SizedBox(
                      width: screenWidth * 0.9,
                      child: const Text(
                        'Get high-quality camping equipment when you need it, where you need it. Start your adventure today!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          height: 1.6,
                          fontFamily: 'Alexandria',
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 50),
                  
                  // Action buttons
                  ScaleTransition(
                    scale: _buttonAnimation,
                    child: _buildActionButtons(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Sign In button
        _buildModernButton(
          text: 'Sign In',
          onTap: () => Navigator.pushNamed(context, AppRoutes.signIn),
          isPrimary: true,
          delay: 0,
        ),
        
        const SizedBox(height: 16),
        
        // Sign Up button  
        _buildModernButton(
          text: 'Sign Up',
          onTap: () => Navigator.pushNamed(context, AppRoutes.signUp),
          isPrimary: false,
          delay: 200,
        ),
      ],
    );
  }

  Widget _buildModernButton({
    required String text,
    required VoidCallback onTap,
    required bool isPrimary,
    required int delay,
  }) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + delay),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: GestureDetector(
            onTap: onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                color: isPrimary ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(28),
                border: isPrimary 
                  ? null 
                  : Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                boxShadow: isPrimary ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(0, 4),
                    blurRadius: 12,
                    spreadRadius: 0,
                  ),
                ] : null,
              ),
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(
                    color: isPrimary ? const Color(0xFF2D5016) : Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Alexandria',
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
