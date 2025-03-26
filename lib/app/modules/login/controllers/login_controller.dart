import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotpot/app/data/base_common.dart';
import 'package:hotpot/app/data/service.dart';
import 'package:hotpot/app/model/account.dart';

import '/app/routes/app_pages.dart';
//

class LoginController extends GetxController {
  //TODO: Implement LoginController

  final count = 0.obs;
  TextEditingController emailController = TextEditingController(text: '');
  TextEditingController passwordController = TextEditingController(text: '');
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  Rx<String> phoneError = ''.obs;
  Rx<String> passwordError = ''.obs;
  String deviceToken = '';

  final isLoading = false.obs;
  final visiblePassword = false.obs;
  @override
  void onInit() {
    String? deviceToken;

    firebaseMessaging.requestPermission();
    firebaseMessaging.getToken().then((v) {
      deviceToken = v;
      log('Device Token: $deviceToken');
    });
    super.onInit();
  }

  void validationPhone() {
    // if (emailController.text.trim().isEmpty) {
    //   phoneError.value = 'Email can not blank';
    //   return;
    // }
    // if (!emailController.text.trim().isEmail) {
    //   phoneError.value = 'Email wrong format';
    //   return;
    // }
    phoneError.value = '';
  }

  void validationPassword() {
    // if (passwordController.text.trim().isEmpty) {
    // passwordError.value = 'Password can not blank';
    //   return;
    // }
    passwordError.value = '';
  }

  Future<void> login() async {
    try {
      if (!isLoading.value) {
        isLoading.value = true;
        UserAccount account = await ServiceData.login(
            userName: emailController.text,
            password: passwordController.text,
            tokenDevice: deviceToken);
        BaseCommon.instance.account = account;
        Get.offAllNamed(Routes.HOME);
      }
    } catch (e) {
      log(e.toString());
      isLoading.value = false;
    }
  }
}
