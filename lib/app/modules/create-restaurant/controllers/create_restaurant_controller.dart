import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotpot/app/data/service.dart';
import 'package:hotpot/app/model/restaurant.dart';
import 'package:hotpot/app/modules/list-restaurant/controllers/list_restaurant_controller.dart';
import 'package:hotpot/app/modules/restaurant-detail/controllers/restaurant_detail_controller.dart';

class CreateRestaurantController extends GetxController {
  //TODO: Implement CreateRestaurantController
  CreateRestaurantController({required this.restaurant});
  Restaurant restaurant;

  TextEditingController nameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  Rx<Restaurant> restaurantView = Restaurant().obs;

  final isLoading = true.obs;

  @override
  void onInit() {
    restaurantView.value = restaurant;
    if (restaurant.restaurantId != null) {
      nameController.text = restaurant.name ?? '';
      locationController.text = restaurant.location ?? '';
    }
    super.onInit();
  }

  onTapAction() async {
    if (restaurant.restaurantId != null) {
      updateRestaurant();
    } else {
      createRestaurant();
    }
  }

  updateRestaurant() async {
    try {
      await ServiceData.updateRestaurant(restaurant.restaurantId!, {
        "restaurantId": restaurant.restaurantId,
        "name": nameController.text,
        "location": locationController.text
      });
      Get.back();
      Get.snackbar('Thông báo', 'Cập nhật thành công',
          colorText: Colors.white, backgroundColor: Colors.green);
      Get.find<RestaurantDetailController>().fetchData();
    } catch (e) {
      log(e.toString());
    }
  }

  createRestaurant() async {
    try {
      await ServiceData.createRestaurant({
        "name": nameController.text,
        "restaurantId": 0,
        "location": locationController.text
      });
      Get.back();
      Get.snackbar('Thông báo', 'Tạo thành công',
          colorText: Colors.white, backgroundColor: Colors.green);
      Get.find<ListRestaurantController>().fetchData();
    } catch (e) {
      log(e.toString());
    }
  }
}
