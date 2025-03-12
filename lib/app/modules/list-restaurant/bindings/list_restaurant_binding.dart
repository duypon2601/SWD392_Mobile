import 'package:get/get.dart';

import '../controllers/list_restaurant_controller.dart';

class ListRestaurantBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListRestaurantController>(
      () => ListRestaurantController(),
    );
  }
}
