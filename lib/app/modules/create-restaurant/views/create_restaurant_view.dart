import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotpot/resources/color_manager.dart';
import 'package:hotpot/resources/form_field_widget.dart';
import 'package:hotpot/resources/reponsive_utils.dart';
import 'package:hotpot/resources/text_style.dart';

import '../controllers/create_restaurant_controller.dart';

class CreateRestaurantView extends GetView<CreateRestaurantController> {
  const CreateRestaurantView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorsManager.primary,
          title: Obx(
            () => TextConstant.titleH2(context,
                text: controller.restaurantView.value.restaurantId != null
                    ? 'Chi tiết'
                    : "Tạo mới",
                fontWeight: FontWeight.w500,
                color: Colors.white),
          ),
          centerTitle: true,
          actions: [
            controller.restaurantView.value.restaurantId != null
                ? const Icon(
                    Icons.remove_circle_outlined,
                    color: Colors.white,
                  )
                : const SizedBox()
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
                      'assets/restaurant.png',
                      height: UtilsReponsive.height(80, context),
                      width: UtilsReponsive.height(80, context),
                    ),
                  ),
                  TextConstant.subTile3(context, text: 'Tên chi nhánh'),
                  FormFieldWidget(
                    radiusBorder: 15,
                    focusColor: ColorsManager.primary,
                    borderColor: Colors.grey,
                    padding: 20,
                    setValueFunc: (v) {},
                    controllerEditting: controller.nameController,
                  ),
                  SizedBoxConst.size(context: context),
                  TextConstant.subTile3(context, text: 'Địa chỉ'),
                  FormFieldWidget(
                    radiusBorder: 15,
                    padding: 20,
                    borderColor: Colors.grey,
                    focusColor: ColorsManager.primary,
                    setValueFunc: (v) {},
                    controllerEditting: controller.locationController,
                  ),
                  SizedBoxConst.size(context: context),
                  Center(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: ColorsManager.primary),
                        onPressed: () {
                          controller.onTapAction();
                        },
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
