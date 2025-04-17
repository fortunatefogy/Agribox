import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize; // To define AppBar size

  CustomAppBar({Key? key})
      : preferredSize = const Size.fromHeight(90), // Set AppBar height
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      centerTitle: true,
      toolbarHeight: 90, // Increased AppBar height
      title: Row(
        children: [
          // App Logo on the left
          Image.asset(
            'assets/logo.png', // Replace with the path to your app's logo
            height: 80, // Adjust the height to fit the increased AppBar size
          ),
          const SizedBox(width: 12), // Add spacing between the logo and text
          // App Name
          Text(
            'Agribox',
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold, // Increased font size
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.home, size: 30), // Increased icon size
          onPressed: () {
            Navigator.pushNamed(context, '/home');
          },
        ),
      ],
    );
  }
}