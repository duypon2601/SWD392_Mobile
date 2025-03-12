import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotpot/app/model/user_data.dart';
import 'package:hotpot/app/routes/app_pages.dart';
import 'package:hotpot/resources/color_manager.dart';
import 'package:hotpot/resources/reponsive_utils.dart';
import 'package:hotpot/resources/text_style.dart';
import 'package:hotpot/resources/util_common.dart';

import '../controllers/restaurant_detail_controller.dart';

class RestaurantDetailView extends GetView<RestaurantDetailController> {
  const RestaurantDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsManager.primary,
        title: TextConstant.titleH2(context,
            text: 'Chi tiết chi nhánh',
            fontWeight: FontWeight.w500,
            color: Colors.white),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              Get.toNamed(Routes.CREATE_RESTAURANT,
                  arguments: controller.restaurantView.value);
            },
            child: const Icon(
              Icons.edit,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: Obx(
        () => controller.isLoading.value
            ? Center(
                child: CupertinoActivityIndicator(
                  color: ColorsManager.primary,
                ),
              )
            : Stack(
                children: [
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Image.asset('assets/moon.png')),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: UtilCommon.shadowBox(context,
                              isActive: true,
                              colorSd: Colors.grey,
                              colorBg: Colors.white),
                          width: double.infinity,
                          height: UtilsReponsive.height(150, context),
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/restaurant.png',
                              ),
                              SizedBoxConst.sizeWith(context: context),
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextConstant.subTile3(context,
                                      text:
                                          '${controller.restaurantView.value.name}',
                                      color: ColorsManager.primary),
                                  SizedBoxConst.size(context: context),
                                  TextConstant.subTile3(context,
                                      text: 'Quản lý: Nguyễn Văn A'),
                                  SizedBoxConst.size(context: context),
                                  TextConstant.subTile3(context,
                                      text:
                                          'Số lượng nhân viên: ${controller.listEmployee.value.length}')
                                ],
                              ))
                            ],
                          ),
                        ),
                        SizedBoxConst.size(context: context),
                        SizedBoxConst.size(context: context),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: UtilsReponsive.height(15, context)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextConstant.titleH3(context,
                                  text: 'Danh sách nhân viên'),
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed(Routes.CREATE_USER,
                                      arguments: UserData(
                                          restaurantId: controller
                                              .restaurant.restaurantId));
                                },
                                child: TextConstant.content(context,
                                    text: 'Thêm nhân viên mới',
                                    color: ColorsManager.primary),
                              ),
                            ],
                          ),
                        ),
                        ListView.separated(
                            padding: EdgeInsets.all(
                                UtilsReponsive.height(15, context)),
                            shrinkWrap: true,
                            itemCount: controller.listEmployee.value.length,
                            separatorBuilder: (context, index) =>
                                SizedBoxConst.size(context: context),
                            itemBuilder: (context, index) => GestureDetector(
                                  onTap: () {
                                    Get.toNamed(Routes.CREATE_USER,
                                        arguments:
                                            controller.listEmployee[index]);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(
                                        UtilsReponsive.height(10, context)),
                                    decoration: UtilCommon.shadowBox(context,
                                        isActive: true,
                                        colorSd: Colors.grey,
                                        colorBg: Colors.white),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          'assets/user.png',
                                          height: UtilsReponsive.height(
                                              35, context),
                                          width: UtilsReponsive.height(
                                              35, context),
                                        ),
                                        SizedBoxConst.sizeWith(
                                            context: context),
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            TextConstant.subTile3(context,
                                                text:
                                                    '${controller.listEmployee.value[index].name}'),
                                            TextConstant.subTile3(context,
                                                text:
                                                    'Chức vụ:  ${controller.listEmployee.value[index].role}'),
                                            TextConstant.content(context,
                                                text:
                                                    'Ngày tham gia: 12/12/2022')
                                          ],
                                        )),
                                      ],
                                    ),
                                  ),
                                ))
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
