import 'package:get/get.dart';
import 'package:hotpot/app/data/service.dart';
import 'package:hotpot/app/model/restaurant.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  final isLoading = false.obs;
  RxList<Restaurant> listRestaurant = <Restaurant>[].obs;

  @override
  void onInit() {
    isLoading(true);
    fetchData().then((v) {
      isLoading(false);
    });
    super.onInit();
  }

  fetchData() async {
    ServiceData.getListRestaurant().then((v) {
      listRestaurant.value = v;
    });
  }
}
