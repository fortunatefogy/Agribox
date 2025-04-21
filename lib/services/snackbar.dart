import 'package:flutter/material.dart';

class CustomSnackbar {
  static void showSnackbar(BuildContext context, String message) {
    final snackbar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black, // Text color
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.green[100], // Background color
      behavior: SnackBarBehavior.floating, // Makes it float
      elevation: 6.0, // Adds shadow for depth
      margin: const EdgeInsets.symmetric(
          horizontal: 500, vertical: 8), // Reduce horizontal margin
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Rounded corners
      ),
      action: SnackBarAction(
        label: 'OK',
        textColor: Colors.black, // Color of the action button
        onPressed: () {
          // Dismiss the Snackbar
        },
      ),
      duration: const Duration(seconds: 4), // Snackbar display duration
    );

    // Show the Snackbar
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
