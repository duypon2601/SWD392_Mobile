import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hotpot/app/data/service.dart';
import 'package:hotpot/app/model/restaurant.dart';
import 'package:hotpot/resources/color_manager.dart';
import 'package:hotpot/resources/reponsive_utils.dart';
import 'package:hotpot/resources/text_style.dart';
import 'package:hotpot/resources/util_common.dart';
import 'package:intl/intl.dart';

class CardRes extends StatefulWidget {
  CardRes({super.key, required this.item});
  Restaurant item;

  @override
  State<CardRes> createState() => _CardResState();
}

class _CardResState extends State<CardRes> {
  bool isLoading = true;
  double revenue = 0;
  @override
  void initState() {
    // TODO: implement initState
    ServiceData.getRevenue(
      startDate: DateFormat('yyyy-MM-dd').format(
        DateTime(DateTime.now().year, DateTime.now().month, 1),
      ),
      idRes: widget.item.restaurantId,
      endate: DateFormat('yyyy-MM-dd').format(
        DateTime(DateTime.now().year, DateTime.now().month + 1, 0),
      ),
    ).then((v) {
      setState(() {
        revenue = v;
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  color: Colors.white, text: '${widget.item.name}'),
              SizedBoxConst.size(context: context, size: 5),
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Colors.white,
                    size: 14,
                  ),
                  Expanded(
                    child: TextConstant.content(context,
                        color: Colors.white, text: '${widget.item.location}'),
                  ),
                ],
              ),
              SizedBoxConst.size(context: context, size: 5),
              isLoading
                  ? const CupertinoActivityIndicator()
                  : _rowText(context,
                      text1: 'Doanh thu',
                      text2: UtilCommon.formatMoney(revenue)),
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
