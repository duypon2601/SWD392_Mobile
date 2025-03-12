import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
              text: 'Chi nhánh Nguyễn Văn A',
              fontWeight: FontWeight.w500,
              color: Colors.white),
          centerTitle: true,
          actions: [
            GestureDetector(
              onTap: () {
                Get.toNamed(Routes.CREATE_RESTAURANT);
              },
              child: const Icon(
                Icons.edit,
                color: Colors.white,
              ),
            )
          ],
        ),
        body: Stack(
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
                                text: 'Quản lý: Nguyễn Văn A'),
                            SizedBoxConst.size(context: context),
                            TextConstant.subTile3(context,
                                text: 'Số lượng nhân viên: 100')
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
                            Get.toNamed(Routes.CREATE_USER);
                          },
                          child: TextConstant.content(context,
                              text: 'Thêm nhân viên mới',
                              color: ColorsManager.primary),
                        ),
                      ],
                    ),
                  ),
                  ListView.separated(
                      padding:
                          EdgeInsets.all(UtilsReponsive.height(15, context)),
                      shrinkWrap: true,
                      itemCount: 10,
                      separatorBuilder: (context, index) =>
                          SizedBoxConst.size(context: context),
                      itemBuilder: (context, index) => GestureDetector(
                            onTap: () {
                              Get.toNamed(Routes.EMPLOYEE_DETAIL);
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
                                    height: UtilsReponsive.height(35, context),
                                    width: UtilsReponsive.height(35, context),
                                  ),
                                  SizedBoxConst.sizeWith(context: context),
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextConstant.subTile3(context,
                                          text: 'Nguyễn Văn A'),
                                      TextConstant.subTile3(context,
                                          text: 'Chức vụ: Nhân viên'),
                                      TextConstant.content(context,
                                          text: 'Ngày tham gia: 12/12/2022')
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
        ));
  }
}
