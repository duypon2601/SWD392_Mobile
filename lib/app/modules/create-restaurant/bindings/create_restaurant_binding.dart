import 'package:get/get.dart';
import 'package:hotpot/app/model/restaurant.dart';

import '../controllers/create_restaurant_controller.dart';

class CreateRestaurantBinding extends Bindings {
  @override
  void dependencies() {
    Restaurant item = Get.arguments as Restaurant;
    Get.lazyPut<CreateRestaurantController>(
      () => CreateRestaurantController(restaurant: item),
    );
  }
}
