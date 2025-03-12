import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotpot/app/routes/app_pages.dart';
import 'package:hotpot/resources/color_manager.dart';
import 'package:hotpot/resources/reponsive_utils.dart';
import 'package:hotpot/resources/text_style.dart';
import 'package:hotpot/resources/util_common.dart';

import '../controllers/list_restaurant_controller.dart';

class ListRestaurantView extends GetView<ListRestaurantController> {
  const ListRestaurantView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorsManager.primary,
          title: TextConstant.titleH2(context,
              text: 'Các chi nhánh',
              fontWeight: FontWeight.w500,
              color: Colors.white),
          centerTitle: true,
          actions: [
            GestureDetector(
              onTap: () {
                Get.toNamed(Routes.CREATE_RESTAURANT);
              },
              child: const Icon(
                Icons.add,
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
            ListView.separated(
              padding: EdgeInsets.all(UtilsReponsive.height(15, context)),
              shrinkWrap: true,
              itemCount: 10,
              separatorBuilder: (context, index) =>
                  SizedBoxConst.size(context: context),
              itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.RESTAURANT_DETAIL);
                  },
                  child: _itemRestaurant(context)),
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
