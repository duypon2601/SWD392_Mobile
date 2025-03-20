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
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          // Background design
          Positioned(
            top: -(UtilsReponsive.height(20, context)),
            right: -(UtilsReponsive.height(120, context)),
            child: Image.asset(
              'assets/moon.png',
              opacity: const AlwaysStoppedAnimation(0.3),
            ),
          ),
          
          // Main content
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: UtilsReponsive.height(24, context), 
              vertical: UtilsReponsive.height(100, context)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Logo or Title
                Text(
                  'Moon-HotPot',
                  style: GoogleFonts.montserrat(
                    fontSize: UtilsReponsive.height(32, context),
                    fontWeight: FontWeight.bold,
                    color: ColorsManager.primary,
                    letterSpacing: 1.5,
                  ),
                ),
                
                Text(
                  'Restaurant Management',
                  style: GoogleFonts.montserrat(
                    fontSize: UtilsReponsive.height(16, context),
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[600],
                  ),
                ),
                
                SizedBox(height: size.height * 0.06),
                
                // Login Form Container
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(size.height * 0.03),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20), 
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 3,
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Welcome Section
                      Center(
                        child: Text(
                          'Welcome Back',
                          style: GoogleFonts.montserrat(
                            fontSize: UtilsReponsive.height(22, context),
                            fontWeight: FontWeight.w600,
                            color: ColorsManager.primary,
                          ),
                        ),
                      ),
                      
                      Center(
                        child: Text(
                          'Sign in to continue',
                          style: GoogleFonts.montserrat(
                            fontSize: UtilsReponsive.height(14, context),
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      
                      SizedBox(height: size.height * 0.04),
                      
                      // Username Field
                      Text(
                        'Username',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500,
                          color: ColorsManager.primary,
                          fontSize: UtilsReponsive.height(14, context),
                        ),
                      ),
                      
                      SizedBox(height: size.height * 0.01),
                      
                      Obx(() => FormFieldWidget(
                        padding: 20,
                        controllerEditting: controller.emailController,
                        errorText: controller.phoneError.value,
                        setValueFunc: (value) {
                          controller.validationPhone();
                        },
                        borderColor: Colors.grey[300]!,
                        radiusBorder: 12,
                        prefixIcon: const Icon(Icons.person_outline),
                      )),
                      
                      SizedBox(height: size.height * 0.025),
                      
                      // Password Field
                      Text(
                        'Password',
                        style: GoogleFonts.montserrat(
                          color: ColorsManager.primary,
                          fontWeight: FontWeight.w500,
                          fontSize: UtilsReponsive.height(14, context),
                        ),
                      ),
                      
                      SizedBox(height: size.height * 0.01),
                      
                      Obx(() => FormFieldWidget(
                        errorText: controller.passwordError.value,
                        controllerEditting: controller.passwordController,
                        padding: 20,
                        setValueFunc: (value) {
                          controller.validationPassword();
                        },
                        borderColor: Colors.grey[300]!,
                        isObscureText: !controller.visiblePassword.value,
                        radiusBorder: 12,
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            controller.visiblePassword.value =
                                !controller.visiblePassword.value;
                          },
                          child: Icon(controller.visiblePassword.value
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined),
                        ),
                      )),
                      
                      SizedBox(height: size.height * 0.05),
                      
                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        height: UtilsReponsive.height(50, context),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorsManager.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () async {
                            await controller.login();
                          },
                          child: Obx(() => controller.isLoading.value
                            ? const CupertinoActivityIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                'Sign In',
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontSize: UtilsReponsive.height(16, context),
                                ),
                              ),
                          ),
                        ),
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
}
