// To parse this JSON data, do
//
//     final restaurant = restaurantFromJson(jsonString);

import 'dart:convert';

Restaurant restaurantFromJson(String str) => Restaurant.fromJson(json.decode(str));

String restaurantToJson(Restaurant data) => json.encode(data.toJson());

class Restaurant {
    int? restaurantId;
    String? name;
    String? location;

    Restaurant({
        this.restaurantId,
        this.name,
        this.location,
    });

    Restaurant copyWith({
        int? restaurantId,
        String? name,
        String? location,
    }) => 
        Restaurant(
            restaurantId: restaurantId ?? this.restaurantId,
            name: name ?? this.name,
            location: location ?? this.location,
        );

    factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
        restaurantId: json["restaurantId"],
        name: json["name"],
        location: json["location"],
    );

    Map<String, dynamic> toJson() => {
        "restaurantId": restaurantId,
        "name": name,
        "location": location,
    };
}
