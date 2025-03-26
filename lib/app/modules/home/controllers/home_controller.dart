import 'package:get/get.dart';
import 'package:hotpot/app/data/service.dart';
import 'package:hotpot/app/model/restaurant.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  final isLoading = false.obs;
  final isLoading1 = false.obs;
  final isLoading2 = false.obs;
  final isLoading3 = false.obs;

  final currentMonth = 0.0.obs;
  final threeMonth = 0.0.obs;
  final sixMonth = 0.0.obs;

  RxList<Restaurant> listRestaurant = <Restaurant>[].obs;

  @override
  void onInit() {
    isLoading(true);
    isLoading1(true);
    isLoading2(true);
    isLoading3(true);
    fetchOverRevenues(
            startDate: DateFormat('yyyy-MM-dd').format(
              DateTime(DateTime.now().year, DateTime.now().month, 1),
            ),
            endDate: DateFormat('yyyy-MM-dd').format(
              DateTime(DateTime.now().year, DateTime.now().month + 1, 0),
            ),
            value: currentMonth)
        .then((v) => isLoading1(false));
    fetchOverRevenues(
            startDate: DateFormat('yyyy-MM-dd').format(
              DateTime(DateTime.now().year, DateTime.now().month + 1, 0),
            ),
            endDate: DateFormat('yyyy-MM-dd').format(
              DateTime(DateTime.now().year, DateTime.now().month - 3, 1),
            ),
            value: threeMonth)
        .then((v) => isLoading2(false));
    fetchOverRevenues(
            startDate: DateFormat('yyyy-MM-dd').format(
              DateTime(DateTime.now().year, DateTime.now().month + 1, 0),
            ),
            endDate: DateFormat('yyyy-MM-dd').format(
              DateTime(DateTime.now().year, DateTime.now().month - 6, 1),
            ),
            value: sixMonth)
        .then((v) => isLoading3(false));

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

  fetchOverRevenues(
      {required String startDate,
      required String endDate,
      required Rx<double> value}) async {
    ServiceData.getRevenue(startDate: startDate, endate: endDate).then((v) {
      value.value = v;
    });
  }
}
