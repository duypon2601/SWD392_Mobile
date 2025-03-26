import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hotpot/app/data/service.dart';
import 'package:hotpot/app/model/restaurant.dart';
import 'package:hotpot/app/model/user_data.dart';
import 'package:intl/intl.dart';

class RestaurantDetailController extends GetxController {
  //TODO: Implement RestaurantDetailController
  RestaurantDetailController({required this.restaurant});
  Restaurant restaurant;
  final isLoading = true.obs;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  Rx<Restaurant> restaurantView = Restaurant().obs;
  RxList<UserData> listEmployee = <UserData>[].obs;

  final startDate = DateTime.now().obs;
  final endDate = DateTime.now().obs;

  final revene = 0.0.obs;
  final isLoading2 = true.obs;

  @override
  void onInit() {
    fetchData().then((v) {
      isLoading(false);
    });
    fetchOverRevenues(
      startDate: DateFormat('yyyy-MM-dd').format(
        DateTime(DateTime.now().year, DateTime.now().month, 1),
      ),
      endDate: DateFormat('yyyy-MM-dd').format(
        DateTime(DateTime.now().year, DateTime.now().month + 1, 0),
      ),
    );
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

  fetchOverRevenues({
    required String startDate,
    required String endDate,
  }) async {
    isLoading2.value = true;
    ServiceData.getRevenue(
            startDate: startDate,
            endate: endDate,
            idRes: restaurant.restaurantId)
        .then((v) {
      revene.value = v;
      isLoading2.value = false;
    });
  }
}
