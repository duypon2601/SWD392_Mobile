import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hotpot/app/data/service.dart';
import 'package:hotpot/app/model/restaurant.dart';
import 'package:hotpot/app/model/user_data.dart';

class RestaurantDetailController extends GetxController {
  //TODO: Implement RestaurantDetailController
  RestaurantDetailController({required this.restaurant});
  Restaurant restaurant;
  final isLoading = true.obs;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  Rx<Restaurant> restaurantView = Restaurant().obs;
  RxList<UserData> listEmployee = <UserData>[].obs;

  @override
  void onInit() {
    fetchData().then((v) {
      isLoading(false);
    });
    super.onInit();
  }

  fetchData() async {
    isLoading(true);
    restaurantView.value =
        await ServiceData.getListRestaurantById(restaurant.restaurantId!);
    listEmployee.value =
        await ServiceData.getUsersByIdRestaurant(restaurant.restaurantId!);
    isLoading(false);
  }
}
