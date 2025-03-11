// user_model.dart
class User {
  final int userId;
  final String name;
  final String restaurantName;
  final String email;
  final String username;
  final String? password;
  final String role;
  final String token;

  User({
    required this.userId,
    required this.name,
    required this.restaurantName,
    required this.email,
    required this.username,
    this.password,
    required this.role,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'] ?? 0,
      name: json['name'] ?? '',
      restaurantName: json['restaurant_name'] ?? '',
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      password: json['password'],
      role: json['role'] ?? '',
      token: json['token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
      'restaurant_name': restaurantName,
      'email': email,
      'username': username,
      'password': password,
      'role': role,
      'token': token,
    };
  }
}

// login_response.dart
class LoginResponse {
  final User data;
  final String? message;
  final bool success;

  LoginResponse({
    required this.data,
    this.message,
    required this.success,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      data: User.fromJson(json['data'] ?? {}),
      message: json['message'],
      success: json['success'] ?? true,
    );
  }
}