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
    super.onInit();
    _initializeFirebaseMessaging();
  }

  Future<void> _initializeFirebaseMessaging() async {
    try {
      await firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      
      deviceToken = await firebaseMessaging.getToken() ?? '';
      log('Device Token initialized: $deviceToken');
    } catch (e) {
      log('Error initializing Firebase Messaging: $e');
    }
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
        
        // Đảm bảo chúng ta có token trước khi đăng nhập
        if (deviceToken.isEmpty) {
          deviceToken = await firebaseMessaging.getToken() ?? '';
          log('Lấy token trước khi đăng nhập: $deviceToken');
        }
        
        log('Đang đăng nhập với token: $deviceToken');
        UserAccount account = await ServiceData.login(
            userName: emailController.text,
            password: passwordController.text,
            tokenDevice: deviceToken);
        
        log('Đăng nhập thành công cho user: ${account.userId}');
        BaseCommon.instance.account = account;
        Get.offAllNamed(Routes.HOME);
      }
    } catch (e) {
      log('Lỗi đăng nhập: $e');
      isLoading.value = false;
      Get.snackbar('Lỗi', 'Đăng nhập thất bại: ${e.toString()}',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
