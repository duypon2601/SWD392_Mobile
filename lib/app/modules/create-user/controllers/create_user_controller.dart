import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class CreateUserController extends GetxController {
  //TODO: Implement CreateUserController

  final count = 0.obs;
  TextEditingController nameController = TextEditingController();
  TextEditingController passController = TextEditingController();

  TextEditingController usernameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  void increment() => count.value++;
}
