import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotpot/resources/color_manager.dart';
import 'package:hotpot/resources/form_field_widget.dart';
import 'package:hotpot/resources/reponsive_utils.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
            child: Container(
      color: ColorsManager.primary,
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          Positioned(
            top: -(UtilsReponsive.height(50, context)),
            right: -(UtilsReponsive.height(160, context)),
            child: Image.asset('assets/moon.png')),
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal:  UtilsReponsive.height(20, context), vertical: UtilsReponsive.height(180, context)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Moon-HotPot'.toUpperCase(),
                    style: GoogleFonts.abrilFatface(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.height * 0.03)),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Container(
                  width: double.infinity,
                  // height: size.height * 0.5,
                  padding: EdgeInsets.all(size.height * 0.02),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20), color: Colors.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Text('Email',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: ColorsManager.primary,
                              fontSize: MediaQuery.of(context).size.height * 0.02)),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Obx(() => FormFieldWidget(
                            padding: 20,
                            controllerEditting: controller.emailController,
                            errorText: controller.phoneError.value,
                            setValueFunc: (value) {
                              controller.validationPhone();
                            },
                            borderColor: Colors.cyan,
                            radiusBorder: 15,
                          )),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Text('Mật khẩu',
                          style: TextStyle(
                              color: ColorsManager.primary,
                              fontWeight: FontWeight.w500,
                              fontSize: MediaQuery.of(context).size.height * 0.02)),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Obx(() => FormFieldWidget(
                            errorText: controller.passwordError.value,
                            controllerEditting: controller.passwordController,
                            padding: 20,
                            setValueFunc: (value) {
                              controller.validationPassword();
                            },
                            borderColor: Colors.cyan,
                            isObscureText: !controller.visiblePassword.value,
                            radiusBorder: 15,
                            suffixIcon: GestureDetector(
                                onTap: () {
                                  controller.visiblePassword.value =
                                      !controller.visiblePassword.value;
                                },
                                child: Icon(controller.visiblePassword.value
                                    ? Icons.visibility
                                    : Icons.visibility_off)),
                          )),
                      SizedBox(
                        height: size.height * 0.04,
                      ),
                      SizedBoxConst.size(context: context),
                      ConstrainedBox(
                        constraints: BoxConstraints.tightFor(width: context.width),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            backgroundColor: WidgetStateProperty.all(
                              ColorsManager.primary,
                            ),
                            padding:
                                WidgetStateProperty.all(const EdgeInsets.all(14)),
                          ),
                          child: Obx(() => controller.isLoading.value
                              ? const CupertinoActivityIndicator(
                                  color: Colors.white,
                                )
                              : Text('Đăng nhập',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: MediaQuery.of(context).size.height *
                                          0.02))),
                          onPressed: () async {
                            await controller.login();
                          },
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      SizedBox(
                        height: size.height * 0.05,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )));
  }

  SizedBox _avatar(BuildContext context) {
    return SizedBox(
      height: UtilsReponsive.height(150, context),
      width: UtilsReponsive.height(150, context),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            clipBehavior: Clip.hardEdge,
            height: UtilsReponsive.height(90, context),
            width: UtilsReponsive.height(90, context),
            padding: EdgeInsets.all(UtilsReponsive.height(5, context)),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.white, width: 5),
                shape: BoxShape.circle),
            child: Container(
              clipBehavior: Clip.hardEdge,
              height: UtilsReponsive.height(80, context),
              width: UtilsReponsive.height(80, context),
              decoration: const BoxDecoration(shape: BoxShape.circle),
              // child: Image.asset(
              //   'assets/image_logo.png',
              //   fit: BoxFit.fill,
              // ),
            ),
          ),
        ],
      ),
    );
  }
}
