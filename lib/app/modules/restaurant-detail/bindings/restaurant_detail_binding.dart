import 'package:get/get.dart';
import 'package:hotpot/app/model/restaurant.dart';

import '../controllers/restaurant_detail_controller.dart';

class RestaurantDetailBinding extends Bindings {
  @override
  void dependencies() {
    Restaurant item = Get.arguments as Restaurant;
    Get.lazyPut<RestaurantDetailController>(
      () => RestaurantDetailController(restaurant: item),
    );
  }
}
