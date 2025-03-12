import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotpot/resources/color_manager.dart';
import 'package:hotpot/resources/form_field_widget.dart';
import 'package:hotpot/resources/reponsive_utils.dart';
import 'package:hotpot/resources/text_style.dart';

import '../controllers/create_user_controller.dart';

class CreateUserView extends GetView<CreateUserController> {
  const CreateUserView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorsManager.primary,
          title: TextConstant.titleH2(context,
              text: 'Chi tiết',
              fontWeight: FontWeight.w500,
              color: Colors.white),
          centerTitle: true,
          actions: const [
            Icon(
              Icons.remove_circle_outlined,
              color: Colors.white,
            )
          ],
        ),
        body: Stack(
          children: [
            Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset('assets/moon.png')),
            SingleChildScrollView(
              padding: EdgeInsets.all(UtilsReponsive.height(20, context)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(
                      'assets/user.png',
                      height: UtilsReponsive.height(80, context),
                      width: UtilsReponsive.height(80, context),
                    ),
                  ),
                  TextConstant.subTile3(context, text: 'Họ và tên'),
                  FormFieldWidget(
                    radiusBorder: 15,
                    focusColor: ColorsManager.primary,
                    borderColor: Colors.grey,
                    padding: 20,
                    setValueFunc: (v) {},
                    controllerEditting: controller.nameController,
                  ),
                  SizedBoxConst.size(context: context),
                  TextConstant.subTile3(context, text: 'Email'),
                  FormFieldWidget(
                    radiusBorder: 15,
                    padding: 20,
                    borderColor: Colors.grey,
                    focusColor: ColorsManager.primary,
                    setValueFunc: (v) {},
                    controllerEditting: controller.nameController,
                  ),
                  SizedBoxConst.size(context: context),
                  TextConstant.subTile3(context, text: 'User name'),
                  FormFieldWidget(
                    radiusBorder: 15,
                    padding: 20,
                    borderColor: Colors.grey,
                    focusColor: ColorsManager.primary,
                    setValueFunc: (v) {},
                    controllerEditting: controller.nameController,
                  ),
                  SizedBoxConst.size(context: context),
                  TextConstant.subTile3(context, text: 'Password'),
                  FormFieldWidget(
                    radiusBorder: 15,
                    padding: 20,
                    borderColor: Colors.grey,
                    focusColor: ColorsManager.primary,
                    setValueFunc: (v) {},
                    controllerEditting: controller.passController,
                  ),
                  Center(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: ColorsManager.primary),
                        onPressed: () {},
                        child: TextConstant.subTile1(context,
                            text: 'Cập nhật', color: Colors.white)),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
