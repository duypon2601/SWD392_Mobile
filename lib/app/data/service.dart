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
    if (response.statusCode == 200) {
      final data = json.decode(response.body)["data"];
      return UserAccount.fromJson(data);
    }
    throw Exception(json.decode(response.body)['message']);
  }

  //Restaurant
  static Future<List<Restaurant>> getListRestaurant() async {
    final response = await http.get(Uri.parse(BaseLink.getRestaurants),
        headers: BaseCommon.instance.headerRequest());
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map<Restaurant>((item) => Restaurant.fromJson(item)).toList();
    }
    throw Exception(json.decode(response.body)['message']);
  }

  static Future<Restaurant> getListRestaurantById(int id) async {
    final response = await http.get(Uri.parse("${BaseLink.getResById}/$id"),
        headers: BaseCommon.instance.headerRequest());
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return Restaurant.fromJson(data);
    }
    throw Exception(json.decode(response.body)['message']);
  }

  static Future<bool> createRestaurant(Map<String, dynamic> body) async {
    final response = await http.post(Uri.parse(BaseLink.createRestaurant),
        body: jsonEncode(body), headers: BaseCommon.instance.headerRequest());
    log('createRestaurant ${response.statusCode}');
    if (response.statusCode == 200) {
      return true;
    }
    throw Exception(json.decode(response.body)['message']);
  }

  static Future<bool> updateRestaurant(
      int id, Map<String, dynamic> body) async {
    final response = await http.put(Uri.parse("${BaseLink.getResById}/$id"),
        headers: BaseCommon.instance.headerRequest(), body: jsonEncode(body));
    log("updateRestaurant payload: ${body.toString()}");
    log('Body ${response.body}');
    if (response.statusCode == 200) {
      return true;
    }
    throw Exception(json.decode(response.body)['message']);
  }

  static Future<bool> deleteRestaurant(String id) async {
    throw Exception();
  }
  //user

  static Future<bool> createNewUser(
      int idRestaurant, Map<String, dynamic> body) async {
    final response = await http.post(
        Uri.parse("${BaseLink.endPointUser}/create"),
        headers: BaseCommon.instance.headerRequest(),
        body: jsonEncode(body));
    log("createNewUser payload: ${body.toString()}");
    log('Body ${response.body}');
    if (response.statusCode == 201) {
      return true;
    }
    throw Exception(json.decode(response.body)['message']);
  }

  static Future<bool> updateUser(int idUser, Map<String, dynamic> body) async {
    final response = await http.put(
        Uri.parse("${BaseLink.endPointUser}/$idUser"),
        headers: BaseCommon.instance.headerRequest(),
        body: jsonEncode(body));
    log("updateUser payload: ${body.toString()}");
    log('Body ${response.body}');
    if (response.statusCode == 200) {
      return true;
    }
    throw Exception(json.decode(response.body)['message']);
  }

  static Future<bool> deleteUser(int idUser) async {
    final response = await http.delete(
      Uri.parse("${BaseLink.endPointUser}/delete/$idUser"),
      headers: BaseCommon.instance.headerRequest(),
    );
    log("deleteUser ");
    log('Body ${response.body}');
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    }
    throw Exception(json.decode(response.body)['message']);
  }

  static Future<UserData> getUserById(String id) async {
    throw Exception();
  }

  static Future<List<UserData>> getUsersByIdRestaurant(int id) async {
    final response = await http.get(
        Uri.parse('${BaseLink.getEmployeeOfRestaurant}/$id'),
        headers: BaseCommon.instance.headerRequest());
    log('getUsersByIdRestaurant ${response.statusCode}');
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map<UserData>((item) => UserData.fromJson(item)).toList();
    }
    throw Exception(json.decode(response.body)['message']);
  }
}
