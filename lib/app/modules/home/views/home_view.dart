import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotpot/app/routes/app_pages.dart';
import 'package:hotpot/resources/color_manager.dart';
import 'package:hotpot/resources/reponsive_utils.dart';
import 'package:hotpot/resources/text_style.dart';
import 'package:hotpot/resources/util_common.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorsManager.primary,
          title: TextConstant.titleH2(context,
              text: 'Trung tâm',
              fontWeight: FontWeight.w500,
              color: Colors.white),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset('assets/moon.png')),
            SingleChildScrollView(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(UtilsReponsive.height(8, context)),
                    decoration: UtilCommon.shadowBox(context,
                        isActive: true,
                        colorBg: ColorsManager.primary.withOpacity(0.9)),
                    // height: UtilsReponsive.height(200, context),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextConstant.subTile2(context,
                            text: 'Thông tin doanh thu', color: Colors.white),
                        SizedBoxConst.size(context: context),
                        _rowText(context,
                            text1: 'Tháng hiện tại',
                            text2: UtilCommon.formatMoney(100000000)),
                        SizedBoxConst.size(context: context),
                        _rowText(context,
                            text1: '3 tháng gần nhất',
                            text2: UtilCommon.formatMoney(100000000)),
                        SizedBoxConst.size(context: context),
                        _rowText(context,
                            text1: '6 tháng gần nhất',
                            text2: UtilCommon.formatMoney(100000000)),
                      ],
                    ),
                  ),
                  SizedBoxConst.size(context: context),
                  SizedBoxConst.size(context: context),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextConstant.titleH3(context, text: 'Top 3 doanh thu'),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes.LIST_RESTAURANT);
                        },
                        child: TextConstant.content(context,
                            text: 'Các chi nhánh khác',
                            color: ColorsManager.primary),
                      ),
                    ],
                  ),
                  SizedBoxConst.size(context: context),
                  ListView.separated(
                    shrinkWrap: true,
                    itemCount: 3,
                    separatorBuilder: (context, index) =>
                        SizedBoxConst.size(context: context),
                    itemBuilder: (context, index) => GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes.RESTAURANT_DETAIL);
                        },
                        child: _itemRestaurant(context)),
                  )
                ],
              ),
            ),
          ],
        ));
  }

  Container _itemRestaurant(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(UtilsReponsive.height(10, context)),
      decoration: UtilCommon.shadowBox(context,
          isActive: true, colorBg: ColorsManager.primary.withOpacity(0.9)),
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextConstant.subTile2(context,
                  color: Colors.white, text: 'Nhà hàng'),
              TextConstant.content(context,
                  color: Colors.white,
                  text: 'Nguyễn Tri Phương, Quận 1, TP.HCM'),
              SizedBoxConst.size(context: context),
              _rowText(context,
                  text1: 'Doanh thu', text2: UtilCommon.formatMoney(100000000)),
            ],
          ))
        ],
      ),
    );
  }

  Row _rowText(BuildContext context,
      {required String text1, required String text2}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
            child: TextConstant.subTile3(context,
                color: Colors.white, text: text1)),
        Expanded(
          child:
              TextConstant.subTile3(context, color: Colors.white, text: text2),
        ),
      ],
    );
  }
}
