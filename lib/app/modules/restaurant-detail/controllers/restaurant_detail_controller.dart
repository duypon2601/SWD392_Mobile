import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class RestaurantDetailController extends GetxController {
  //TODO: Implement RestaurantDetailController

  final count = 0.obs;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  void increment() => count.value++;
}
