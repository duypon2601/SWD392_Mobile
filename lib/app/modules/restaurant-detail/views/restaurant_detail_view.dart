import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotpot/app/model/user_data.dart';
import 'package:hotpot/app/routes/app_pages.dart';
import 'package:hotpot/resources/color_manager.dart';
import 'package:hotpot/resources/reponsive_utils.dart';
import 'package:hotpot/resources/text_style.dart';
import 'package:hotpot/resources/util_common.dart';
import 'package:intl/intl.dart';

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
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.all(8),
                          decoration: UtilCommon.shadowBox(context,
                              isActive: true,
                              colorSd: Colors.grey,
                              colorBg: Colors.white),
                          width: double.infinity,
                          // Removed fixed height to make it adapt to content
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                'assets/restaurant.png',
                                height: UtilsReponsive.height(80, context),
                                width: UtilsReponsive.height(80, context),
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
                                          'Số lượng nhân viên: ${controller.listEmployee.value.length}'),
                                  SizedBoxConst.size(context: context),
                                  Row(
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            _bottomOnceTime(context);
                                          },
                                          child:
                                              const Icon(Icons.calendar_month)),
                                      const SizedBox(width: 10),
                                      TextConstant.subTile3(context,
                                          text: 'Doanh thu:'),
                                      const SizedBox(width: 10),
                                      Obx(() => controller.isLoading2.value
                                          ? const CupertinoActivityIndicator()
                                          : TextConstant.subTile2(context,
                                              textAlign: TextAlign.center,
                                              color: ColorsManager.primary,
                                              fontWeight: FontWeight.bold,
                                              text: UtilCommon.formatMoney(
                                                  controller.revene.value))),
                                    ],
                                  ),
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
                        // Use a ListView.builder instead of ListView.separated for better performance
                        ListView.builder(
                            padding: EdgeInsets.all(
                                UtilsReponsive.height(15, context)),
                            shrinkWrap: true,
                            // This is important! Makes the ListView respect the parent's height constraints
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.listEmployee.value.length,
                            itemBuilder: (context, index) => Padding(
                                  padding: EdgeInsets.only(
                                    bottom: index ==
                                            controller
                                                    .listEmployee.value.length -
                                                1
                                        ? 0
                                        : UtilsReponsive.height(10, context),
                                  ),
                                  child: GestureDetector(
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

  _bottomOnceTime(BuildContext context) {
    Get.bottomSheet(
      Container(
        margin: EdgeInsets.all(UtilsReponsive.height(10, context)),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(UtilsReponsive.height(20, context))),
        height: UtilsReponsive.height(400, context),
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: CalendarDatePicker2(
                config: CalendarDatePicker2Config(
                  currentDate: DateTime.now(),
                  // firstDate: DateTime.now().add(const Duration(days: 1)),
                  calendarType: CalendarDatePicker2Type.range,
                  centerAlignModePicker: true,
                  selectedDayTextStyle: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700),
                  selectedDayHighlightColor: ColorsManager.primary,
                ),
                onValueChanged: (value) async {
                  controller.startDate.value = value.first;
                  controller.endDate.value = value.last;
                },
                value: [controller.startDate.value, controller.endDate.value],
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  controller.fetchOverRevenues(
                    startDate: DateFormat('yyyy-MM-dd')
                        .format(controller.startDate.value),
                    endDate: DateFormat('yyyy-MM-dd').format(
                      controller.endDate.value,
                    ),
                  );
                  Get.back();
                },
                child: const Text('Kiểm tra'))
          ],
        ),
      ),
    );
  }
}
