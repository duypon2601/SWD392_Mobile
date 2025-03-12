// api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import '../Model/user_model.dart';

class ApiService {
  static const String baseUrl = "http://10.0.2.2:8080/api";

  // Singleton pattern
  static final ApiService _instance = ApiService._internal();

  factory ApiService() {
    return _instance;
  }

  ApiService._internal();

  // Login API call
  Future<LoginResponse> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      // Debug response
      if (kDebugMode) {
        print('Login Response: ${response.body}');
        print('Status Code: ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return LoginResponse.fromJson(jsonResponse);
      } else {
        // Handle error cases
        final errorMessage = response.statusCode == 400
            ? 'Invalid credentials'
            : 'Login failed. Please try again.';

        throw Exception(errorMessage);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Login error: $e');
      }
      throw Exception('Network error: $e');
    }
  }

  // Store token in secure storage (implement using flutter_secure_storage)
  Future<void> storeToken(String token) async {
    // This would use secure storage in a real implementation
    if (kDebugMode) {
      print('Token stored: $token');
    }
    // Implementation with secure storage would be:
    // final storage = FlutterSecureStorage();
    // await storage.write(key: 'auth_token', value: token);
  }

  // Get stored token
  Future<String?> getToken() async {
    // Implementation with secure storage would be:
    // final storage = FlutterSecureStorage();
    // return await storage.read(key: 'auth_token');
    return null; // Placeholder
  }

  // Logout (clear token)
  Future<void> logout() async {
    // Implementation with secure storage would be:
    // final storage = FlutterSecureStorage();
    // await storage.delete(key: 'auth_token');
  }
}
