import 'package:get/get.dart';

import '../modules/create-restaurant/bindings/create_restaurant_binding.dart';
import '../modules/create-restaurant/views/create_restaurant_view.dart';
import '../modules/create-user/bindings/create_user_binding.dart';
import '../modules/create-user/views/create_user_view.dart';
import '../modules/employee-detail/bindings/employee_detail_binding.dart';
import '../modules/employee-detail/views/employee_detail_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/list-restaurant/bindings/list_restaurant_binding.dart';
import '../modules/list-restaurant/views/list_restaurant_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/restaurant-detail/bindings/restaurant_detail_binding.dart';
import '../modules/restaurant-detail/views/restaurant_detail_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.LIST_RESTAURANT,
      page: () => const ListRestaurantView(),
      binding: ListRestaurantBinding(),
    ),
    GetPage(
      name: _Paths.RESTAURANT_DETAIL,
      page: () => const RestaurantDetailView(),
      binding: RestaurantDetailBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_USER,
      page: () => const CreateUserView(),
      binding: CreateUserBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_RESTAURANT,
      page: () => const CreateRestaurantView(),
      binding: CreateRestaurantBinding(),
    ),
    GetPage(
      name: _Paths.EMPLOYEE_DETAIL,
      page: () => const EmployeeDetailView(),
      binding: EmployeeDetailBinding(),
    ),
  ];
}
