import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotpot/resources/color_manager.dart';
import 'package:hotpot/resources/reponsive_utils.dart';
import 'package:intl/intl.dart';


class UtilCommon {
  static void snackBar({required String text, bool isFail = false}) {
    Get.snackbar('Note', text,
        colorText: Colors.white,
        backgroundColor: isFail ? Colors.red : Colors.green);
  }

  static String convertDateTime(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String convertDateTimeYMD(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static String convertEEEDateTime(DateTime date) {
    return DateFormat('EEEE, dd MMMM yyyy hh:mm', 'vi_VN').format(date);
  }

  static DateTime combineDateTimeAndTimeOfDay(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  static String formatMoney(double amount) {
    final NumberFormat formatter =
        NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');
    return formatter.format(amount);
  }

  static BoxDecoration shadowBox(BuildContext context,
      {double radiusBorder = 10,
      Color? colorBg,
      Color? colorSd,
      bool isActive = false}) {
    colorSd = colorSd ?? ColorsManager.bgLight2;
    colorBg = colorBg ??
        (isActive ? ColorsManager.scaffoldBg : ColorsManager.bgLight2);
    return BoxDecoration(
      borderRadius:
          BorderRadius.circular(UtilsReponsive.height(radiusBorder, context)),
      color: colorBg,
      boxShadow: !isActive
          ? null
          : [
              BoxShadow(
                color: colorSd,
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(0, 0.5),
              ),
            ],
    );
  }
}
