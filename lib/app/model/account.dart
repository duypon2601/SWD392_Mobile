// To parse this JSON data, do
//
//     final userAccount = userAccountFromJson(jsonString);

import 'dart:convert';

UserAccount userAccountFromJson(String str) => UserAccount.fromJson(json.decode(str));

String userAccountToJson(UserAccount data) => json.encode(data.toJson());

class UserAccount {
    int? userId;
    String? name;
    String? restaurantName;
    String? email;
    String? username;
    String? role;
    String? token;

    UserAccount({
        this.userId,
        this.name,
        this.restaurantName,
        this.email,
        this.username,
        this.role,
        this.token,
    });

    UserAccount copyWith({
        int? userId,
        String? name,
        String? restaurantName,
        String? email,
        String? username,
        String? role,
        String? token,
    }) => 
        UserAccount(
            userId: userId ?? this.userId,
            name: name ?? this.name,
            restaurantName: restaurantName ?? this.restaurantName,
            email: email ?? this.email,
            username: username ?? this.username,
            role: role ?? this.role,
            token: token ?? this.token,
        );

    factory UserAccount.fromJson(Map<String, dynamic> json) => UserAccount(
        userId: json["user_id"],
        name: json["name"],
        restaurantName: json["restaurant_name"],
        email: json["email"],
        username: json["username"],
        role: json["role"],
        token: json["token"],
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId,
        "name": name,
        "restaurant_name": restaurantName,
        "email": email,
        "username": username,
        "role": role,
        "token": token,
    };
}
