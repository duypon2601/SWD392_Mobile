import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotpot/app/data/service.dart';
import 'package:hotpot/app/model/user_data.dart';
import 'package:hotpot/app/modules/restaurant-detail/controllers/restaurant_detail_controller.dart';

class CreateUserController extends GetxController {
  //TODO: Implement CreateUserController
  CreateUserController({required this.employee});
  UserData employee;
  Rx<UserData> employeeView = UserData().obs;

  TextEditingController nameController = TextEditingController();
  TextEditingController passController = TextEditingController();

  TextEditingController usernameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  final isLoading = true.obs;

  @override
  void onInit() {
    employeeView.value = employee;
    if (employee.userId != null) {
      nameController.text = employee.name ?? '';
      emailController.text = employee.email ?? '';
      usernameController.text = employee.username ?? '';
    }
    super.onInit();
  }

  onTapAction() async {
    if (employee.userId != null) {
      updateEmployee();
    } else {
      createEmployee();
    }
  }

  updateEmployee() async {
    try {
      await ServiceData.updateUser(employee.userId!, {
        "name": nameController.text,
        "email": emailController.text,
        "restaurant_id": employee.restaurantId!,
        "role": employeeView.value.role,
        "username": usernameController.text,
      });
      Get.back();
      Get.snackbar('Thông báo', 'Cập nhật thành công',
          colorText: Colors.white, backgroundColor: Colors.green);
      Get.find<RestaurantDetailController>().fetchData();
    } catch (e) {
      log(e.toString());
    }
  }

  createEmployee() async {
    try {
      await ServiceData.createNewUser(employee.restaurantId!, {
        "name": nameController.text,
        "email": emailController.text,
        "username": usernameController.text,
        "password": passController.text,
        "role": employeeView.value.role ?? 'STAFF',
        "restaurant_id": employee.restaurantId!
      });
      Get.back();
      Get.snackbar('Thông báo', 'Tạo thành công',
          colorText: Colors.white, backgroundColor: Colors.green);
      Get.find<RestaurantDetailController>().fetchData();
    } catch (e) {
      log(e.toString());
    }
  }

  deleteUser() async {
    try {
      isLoading(true);
      await ServiceData.deleteUser(employee.userId!);
      Get.back();
      Get.snackbar('Thông báo', 'Xoá thành công',
          colorText: Colors.white, backgroundColor: Colors.green);
      Get.find<RestaurantDetailController>().fetchData();
    } catch (e) {
      isLoading(false);
      Get.snackbar('Thông báo', 'Có gì đó không đúng',
          colorText: Colors.white, backgroundColor: Colors.red);
      log(e.toString());
    }
  }
}
