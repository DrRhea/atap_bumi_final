import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
// import '../../providers/equipment_provider.dart';  // Commented out as it's currently unused
import '../../widgets/bottom_navigation_bar.dart';
import '../../widgets/home/home_header.dart';
import '../../widgets/home/search_bar.dart';
import '../../widgets/home/category_grid.dart';
import '../../widgets/home/featured_products_section.dart';
// import '../../widgets/home/section_header.dart';  // Commented out as it's only used in commented sections
// import '../category/category_screen.dart';  // Commented out as it's only needed for recommendation section

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.user == null && !authProvider.isLoading) {
        authProvider.getCurrentUser();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFBFC),
      body: SafeArea(
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            return Column(
              children: [
                HomeHeader(
                  authProvider: authProvider,
                  screenWidth: screenWidth,
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.04,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: screenHeight * 0.02),
                        
                        HomeSearchBar(screenWidth: screenWidth),
                        
                        SizedBox(height: screenHeight * 0.025),
                        
                        CategoryGrid(screenWidth: screenWidth),
                          SizedBox(height: screenHeight * 0.03),
                        // Commented out "You Might Like" section
                        // _buildRecommendationSection(screenWidth, screenHeight),
                        
                        // SizedBox(height: screenHeight * 0.03),
                        
                        FeaturedProductsSection(
                          screenWidth: screenWidth,
                          maxProducts: 12,
                        ),
                        
                        SizedBox(height: screenHeight * 0.02),
                        
                        // Commented out Outdoor Articles section
                        // _buildArticlesSection(screenWidth, screenHeight),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 0),
    );
  }
  // Commented out "You Might Like" section
  /*
  Widget _buildRecommendationSection(double screenWidth, double screenHeight) {
    final packages = [
      {
        'title': 'Trip Starter Pack',
        'price': '115k',
        'items': 'Tent, Carrier, Sleeping Bag, Accessories',
        'image': 'assets/images/PAKET.png',
      },
      {
        'title': 'Picnic Hangout Pack',
        'price': '90k',
        'items': '4 Portable Chair, 1 Table',
        'image': 'assets/images/PAKET2.png',
      },
      {
        'title': 'Hiking Essentials Pack',
        'price': '80k',
        'items': 'Backpack, Water Bottle, First Aid Kit, Map',
        'image': 'assets/images/PAKET3.png',
      },
      {
        'title': 'Camping Cookout Pack',
        'price': '110k',
        'items': 'Portable Stove, Cookware Set, Utensils',
        'image': 'assets/images/PAKET4.png',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'You Might Like',
          actionText: 'See All',
          onActionPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CategoryScreen()),
            );
          },
          screenWidth: screenWidth,
        ),
        SizedBox(height: screenWidth * 0.04),

        SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: packages.length,
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
            separatorBuilder: (context, index) => SizedBox(width: screenWidth * 0.03),
            itemBuilder: (context, index) {
              return SizedBox(
                width: screenWidth * 0.65,
                child: _buildPackageCard(
                  title: packages[index]['title']!,
                  price: packages[index]['price']!,
                  items: packages[index]['items']!,
                  imagePath: packages[index]['image']!,
                  screenWidth: screenWidth,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
  */
  // Commented out Package Card widget
  /*
  Widget _buildPackageCard({
    required String title,
    required String price,
    required String items,
    required String imagePath,
    required double screenWidth,
  }) {
    return GestureDetector(
      onTap: () => debugPrint('Package selected: $title'),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                    onError: (exception, stackTrace) {
                      debugPrint('Error loading image: $imagePath');
                    },
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.1),
                      ],
                    ),
                  ),
                ),
              ),

              Container(
                height: 80,
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.03,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: screenWidth * 0.036,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Alexandria',
                              color: const Color(0xFF1E293B),
                              height: 1.1,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Expanded(
                            child: Text(
                              items,
                              style: TextStyle(
                                color: const Color(0xFF64748B),
                                fontSize: screenWidth * 0.026,
                                fontFamily: 'Alexandria',
                                height: 1.2,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'From Rp$price',
                          style: TextStyle(
                            fontSize: screenWidth * 0.03,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Alexandria',
                            color: const Color(0xFF7CB342),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: screenWidth * 0.028,
                          color: const Color(0xFF94A3B8),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  */  // Commented out Outdoor Articles section
  /*
  Widget _buildArticlesSection(double screenWidth, double screenHeight) {
    final articles = [
      {
        'title': 'Tent Setup for Beginners',
        'description': 'Learn the essential steps to pitch your tent with ease and confidence.',
        'image': 'assets/images/ARTIKEL1.jpg',
        'readTime': '5 min read',
      },
      {
        'title': 'Choosing the Right Backpack',
        'description': 'A guide to picking the perfect backpack for your trip.',
        'image': 'assets/images/ARTIKEL2.jpg',
        'readTime': '7 min read',
      },
      {
        'title': 'Best Campfire Foods',
        'description': 'Delicious and easy meal ideas for your camping experience.',
        'image': 'assets/images/ARTIKEL3.jpg',
        'readTime': '4 min read',
      },
      {
        'title': 'Essential Hiking Safety Tips',
        'description': 'Stay safe on the trails with these proven guidelines.',
        'image': 'assets/images/ARTIKEL4.jpg',
        'readTime': '6 min read',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Outdoor Articles & Tips',
          actionText: 'See All',
          onActionPressed: () => _navigateToArticles(),
          screenWidth: screenWidth,
        ),
        SizedBox(height: screenWidth * 0.04),

        SizedBox(
          height: 220,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: articles.length,
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
            separatorBuilder: (context, index) => SizedBox(width: screenWidth * 0.03),
            itemBuilder: (context, index) {
              return SizedBox(
                width: screenWidth * 0.7,
                child: _buildArticleCard(
                  title: articles[index]['title']!,
                  description: articles[index]['description']!,
                  imagePath: articles[index]['image']!,
                  readTime: articles[index]['readTime']!,
                  screenWidth: screenWidth,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
  */
  // Commented out Article Card widget
  /*
  Widget _buildArticleCard({
    required String title,
    required String description,
    required String imagePath,
    required String readTime,
    required double screenWidth,
  }) {
    return GestureDetector(
      onTap: () => _navigateToArticleDetail(title),
      child: Container(
        height: 220,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                    onError: (exception, stackTrace) {
                      debugPrint('Error loading article image: $imagePath');
                    },
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.2),
                      ],
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      margin: EdgeInsets.all(screenWidth * 0.03),
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.025,
                        vertical: screenWidth * 0.01,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        readTime,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.025,
                          fontFamily: 'Alexandria',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Container(
                height: 80,
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.03,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: screenWidth * 0.036,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Alexandria',
                        color: const Color(0xFF1E293B),
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: Text(
                        description,
                        style: TextStyle(
                          fontSize: screenWidth * 0.028,
                          color: const Color(0xFF64748B),
                          fontFamily: 'Alexandria',
                          height: 1.3,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  */

  // Commented out navigation methods
  /*
  void _navigateToArticles() {
    debugPrint('Navigate to articles');
    // TODO: Implement navigation to articles page
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => const ArticlesScreen()),
    // );
  }

  void _navigateToArticleDetail(String title) {
    debugPrint('Article selected: $title');
    // TODO: Implement navigation to article detail page
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => ArticleDetailScreen(title: title),
    //   ),
    // );
  }
  */
}