// To parse this JSON data, do
//
//     final userData = userDataFromJson(jsonString);

import 'dart:convert';

UserData userDataFromJson(String str) => UserData.fromJson(json.decode(str));

String userDataToJson(UserData data) => json.encode(data.toJson());

class UserData {
    int? userId;
    String? name;
    String? restaurantName;
    String? email;
    String? username;
    String? role;
    int? restaurantId;

    UserData({
        this.userId,
        this.name,
        this.restaurantName,
        this.email,
        this.username,
        this.role,
        this.restaurantId,
    });

    UserData copyWith({
        int? userId,
        String? name,
        String? restaurantName,
        String? email,
        String? username,
        String? role,
        int? restaurantId,
    }) => 
        UserData(
            userId: userId ?? this.userId,
            name: name ?? this.name,
            restaurantName: restaurantName ?? this.restaurantName,
            email: email ?? this.email,
            username: username ?? this.username,
            role: role ?? this.role,
            restaurantId: restaurantId ?? this.restaurantId,
        );

    factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        userId: json["user_id"],
        name: json["name"],
        restaurantName: json["restaurant_name"],
        email: json["email"],
        username: json["username"],
        role: json["role"],
        restaurantId: json["restaurant_id"],
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId,
        "name": name,
        "restaurant_name": restaurantName,
        "email": email,
        "username": username,
        "role": role,
        "restaurant_id": restaurantId,
    };
}
