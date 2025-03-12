import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class CreateRestaurantController extends GetxController {
  //TODO: Implement CreateRestaurantController

  final count = 0.obs;
  TextEditingController nameController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  void increment() => count.value++;
}
