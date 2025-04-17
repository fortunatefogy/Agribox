import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  int _currentIndex = 0; // For carousel state
  int _selectedNavIndex = 0; // For bottom navigation bar state
  late PageController _pageController;
  Timer? _timer;

  final List<String> _images = [
    'assets/onboarding_images/image1.png',
    'assets/onboarding_images/image2.png',
    'assets/onboarding_images/image3.png',
    'assets/onboarding_images/image2.png',
  ];

  @override
  void initState() {
    super.initState();

    // Initialize the PageController with an initial page offset
    _pageController = PageController(initialPage: 1);

    // Set up a timer to auto-scroll the carousel infinitely
    _timer = Timer.periodic(Duration(seconds: 2), (Timer timer) {
      if (_pageController.hasClients) {
        _pageController.nextPage(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Create a list with extra images at both ends for seamless looping
    final List<String> loopedImages = [
      _images.last, // Add last image at the beginning
      ..._images, // Add all original images
      _images.first // Add first image at the end
    ];

    return Scaffold(
      body: Column(
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
                // SizedBox(height: 8.0),
                Text(
                  'Username', // Username, larger font size
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
            height: 240.0, // Increased height to include padding and indicator
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      // Handle seamless looping
                      if (index == loopedImages.length - 1) {
                        // If user reaches the last page, jump to the first content page (index 1)
                        _pageController.jumpToPage(1);
                        setState(() {
                          _currentIndex = 0;
                        });
                      } else if (index == 0) {
                        // If user reaches the first page, jump to the last content page
                        _pageController.jumpToPage(loopedImages.length - 2);
                        setState(() {
                          _currentIndex = _images.length - 1;
                        });
                      } else {
                        // Update the current index normally
                        setState(() {
                          _currentIndex = (index - 1) % _images.length;
                        });
                      }
                    },
                    itemCount:
                        loopedImages.length, // Total items with extra images
                    itemBuilder: (context, index) {
                      final image = loopedImages[index]; // Access looped images
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0), // Add padding
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(16.0), // Curved borders
                          child: Image.asset(
                            image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
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
                        duration: Duration(milliseconds: 3000),
                        margin: EdgeInsets.symmetric(horizontal: 4.0),
                        height: 4.0, // Fixed height for line shape
                        width: _currentIndex == index
                            ? 24.0
                            : 12.0, // Active indicator is longer
                        decoration: BoxDecoration(
                          color: _currentIndex == index
                              ? Color(0xFF00dF81)
                              : Colors.grey,
                          borderRadius: BorderRadius.circular(
                              2.0), // Slightly rounded edges for line
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Text('Home Screen'),
            ),
          ),
        ],
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
