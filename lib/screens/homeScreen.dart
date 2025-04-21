import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  int _currentIndex = 0; // For carousel state
  int _selectedNavIndex = 0; // For bottom navigation bar state

  final List<String> _images = [
    'assets/onboarding_images/image1.png',
    'assets/onboarding_images/image2.png',
    'assets/onboarding_images/image3.png',
    'assets/onboarding_images/image2.png',
  ];

  @override
  Widget build(BuildContext context) {
    // Calculate dynamic height based on platform
    final double carouselHeight = kIsWeb ? 350.0 : 240.0; // Larger on web
    final int gridColumns = kIsWeb ? 5 : 3; // 5 columns for web, 3 for mobile

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Custom header with static sentence and username
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color.fromARGB(255, 83, 251, 181), Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16.0),
                  bottomRight: Radius.circular(16.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8.0),
                  Text(
                    "Hey....👋🏼", // Static sentence
                    style: GoogleFonts.pacifico(
                      textStyle: TextStyle(
                        fontSize: 20.0,
                        color: Color(0xFF032221),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    'subinr', // Username, larger font size
                    style: GoogleFonts.pacifico(
                      textStyle: TextStyle(
                        fontSize: 32.0,
                        color: Color(0xFF032221),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Color(0xFF00dF81),
                ),
                onChanged: (value) {
                  // Handle search input
                  print('Search query: $value');
                },
              ),
            ),
            SizedBox(
              height: carouselHeight, // Dynamic height for web and mobile
              child: Column(
                children: [
                  Expanded(
                    child: CarouselSlider(
                      options: CarouselOptions(
                        height:
                            carouselHeight - 40.0, // Height for the carousel
                        autoPlay: true, // Enable auto-scrolling
                        autoPlayInterval:
                            Duration(seconds: 3), // Time between slides
                        enlargeCenterPage: true, // Zoom in on the current slide
                        viewportFraction:
                            kIsWeb ? 0.6 : 0.8, // Larger slides on web
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentIndex = index; // Update the current index
                          });
                        },
                      ),
                      items: _images.map((imagePath) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16.0),
                                child: Image.asset(
                                  imagePath,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  // Place the indicator below the image
                  SizedBox(
                    height: 20.0, // Height for the indicator space
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _images
                            .length, // Number of indicators for original images
                        (index) => AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          margin: EdgeInsets.symmetric(horizontal: 4.0),
                          height: 8.0, // Fixed height for circle shape
                          width: _currentIndex == index
                              ? 16.0
                              : 8.0, // Active indicator is larger
                          decoration: BoxDecoration(
                            color: _currentIndex == index
                                ? Color(0xFF00dF81)
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(
                                8.0), // Circular indicators
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Popular Products',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics:
                    NeverScrollableScrollPhysics(), // Disable inner scrolling
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      gridColumns, // Dynamic columns based on platform
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 0.8, // Adjust for card proportions
                ),
                itemCount: 20, // Number of dummy cards
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Center(
                      child: Text(
                        'Card ${index + 1}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Always show labels below icons
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Iconsax.home_1_bulk, size: 40.0),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.category_2_bold, size: 40.0),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.profile_circle_bold, size: 40.0),
            label: 'Account',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.shopping_cart_bold, size: 40.0),
            label: 'Cart',
          ),
        ],
        currentIndex: _selectedNavIndex, // Use separate state for navigation
        selectedItemColor:
            Color(0xFF00dF81), // Set the color for the selected item
        unselectedItemColor: Colors.grey, // Set the color for unselected items
        onTap: (int index) {
          setState(() {
            _selectedNavIndex = index; // Update only the navigation index
          });
        },
      ),
    );
  }
}
