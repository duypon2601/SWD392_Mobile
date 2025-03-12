import 'package:get/get.dart';
import 'package:hotpot/app/data/service.dart';
import 'package:hotpot/app/model/restaurant.dart';

class ListRestaurantController extends GetxController {
  //TODO: Implement ListRestaurantController
  final isLoading = false.obs;
  RxList<Restaurant> listRestaurant = <Restaurant>[].obs;

  @override
  void onInit() {
    fetchData().then((v) {
      isLoading(false);
    });
    super.onInit();
  }

  fetchData() async {
    isLoading(true);
    listRestaurant.value = await ServiceData.getListRestaurant();
    isLoading(false);
  }
}
