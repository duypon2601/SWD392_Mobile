import 'dart:convert';
import 'dart:developer';

import 'package:hotpot/app/data/base_common.dart';
import 'package:hotpot/app/data/base_link.dart';
import 'package:hotpot/app/model/account.dart';
import 'package:hotpot/app/model/restaurant.dart';
import 'package:hotpot/app/model/user_data.dart';
import 'package:http/http.dart' as http;

class ServiceData {
  static Future<UserAccount> login(
      {required String userName, required String password}) async {
    final response = await http.post(Uri.parse(BaseLink.login),
        headers: BaseCommon.instance.headerRequest(isUsingToken: false),
        body: jsonEncode({"username": userName, "password": password}));
    log("payload: ${jsonEncode({"password": password, "username": userName})}");
    log('StatusCode ${response.statusCode} - ${BaseLink.login}');
    log('Body ${response.body}');
    if (response.statusCode == 200) {
      final data = json.decode(response.body)["data"];
      return UserAccount.fromJson(data);
    }
    throw Exception(json.decode(response.body)['message']);
  }

  //Restaurant
  static Future<List<Restaurant>> getListRestaurant() async {
    throw Exception();
  }

  static Future<Restaurant> getListRestaurantById(String id) async {
    throw Exception();
  }

  static Future<bool> createRestaurant(Map<String, dynamic> body) async {
    throw Exception();
  }

  static Future<bool> updateRestaurant(
      String id, Map<String, dynamic> body) async {
    throw Exception();
  }

  static Future<bool> deleteRestaurant(String id) async {
    throw Exception();
  }
  //user

  static Future<bool> createNewUser(
      String idRestaurant, Map<String, dynamic> body) async {
    throw Exception();
  }

  static Future<bool> updateUser(
      String idRestaurant, Map<String, dynamic> body) async {
    throw Exception();
  }

  static Future<bool> deleteUser(
      String idRestaurant, Map<String, dynamic> body) async {
    throw Exception();
  }

  static Future<UserData> getUserById(String id) async {
    throw Exception();
  }

  static Future<List<UserData>> getUsersByIdRestaurant(String id) async {
    throw Exception();
  }
}
