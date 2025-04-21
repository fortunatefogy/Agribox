import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:agribox/models/user.dart';

class ApiService {
  late final String baseUrl;

  ApiService() {
    if (kIsWeb) {
      baseUrl = 'http://localhost:3000/api';
    } else {
      baseUrl = 'http://10.0.2.2:3000/api';
    }
  }

  Future<bool> loginUser(String email, String password) async {
    try {
      print('Attempting login for: $email');
      final response = await http.post(
        Uri.parse('$baseUrl/users/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      ).timeout(Duration(seconds: 10));

      print('Login response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Login successful for: $email');

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_data', jsonEncode(data['user']));

        return true;
      }

      if (response.statusCode >= 400 && response.statusCode < 500) {
        print('Login failed: ${response.body}');
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> registerUser(User user) async {
    try {
      print('Attempting to register user: ${user.email}');

      final response = await http.post(
        Uri.parse('$baseUrl/users/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': user.name,
          'email': user.email,
          'password': user.password,
          'phone': user.phone
        }),
      ).timeout(Duration(seconds: 10));

      print('Registration response status: ${response.statusCode}');
      final responseData = response.body.isNotEmpty
          ? jsonDecode(response.body)
          : {'message': 'Unknown error'};

      if (response.statusCode == 201) {
        print('Registration successful for: ${user.email}');
        return {
          'success': true,
          'message': responseData['message'] ?? 'Registration successful'
        };
      } else {
        print('Registration failed: ${response.body}');
        return {
          'success': false,
          'message': responseData['message'] ?? 'Registration failed'
        };
      }
    } catch (e) {
      print('Registration error: $e');
      return {
        'success': false,
        'message': 'Connection error: ${e.toString()}'
      };
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_data');
    print('User logged out');
  }

  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user_data');

    if (userData != null) {
      print('Retrieved current user from storage');
      return User.fromJson(jsonDecode(userData));
    }
    print('No current user found');
    return null;
  }
}
