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
                    ? 'Chi tiết nhà hàng'
                    : "Tạo nhà hàng mới",
                fontWeight: FontWeight.w500,
                color: Colors.white),
          ),
          centerTitle: true,
          elevation: 0,
          actions: [
            controller.restaurantView.value.restaurantId != null
                ? IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      _showDeleteConfirmation(context);
                    },
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
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: ColorsManager.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        'assets/restaurant.png',
                        height: UtilsReponsive.height(80, context),
                        width: UtilsReponsive.height(80, context),
                      ),
                    ),
                  ),
                  SizedBoxConst.size(context: context, size: 30),
                  _buildFormField(
                    context,
                    'Tên nhà hàng',
                    Icons.restaurant,
                    controller.nameController,
                    'Nhập tên nhà hàng',
                  ),
                  SizedBoxConst.size(context: context),
                  _buildFormField(
                    context,
                    'Địa chỉ',
                    Icons.location_on,
                    controller.locationController,
                    'Nhập địa chỉ nhà hàng',
                  ),
                  SizedBoxConst.size(context: context, size: 40),
                  Center(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorsManager.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          controller.onTapAction();
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              controller.restaurantView.value.restaurantId != null
                                  ? Icons.save
                                  : Icons.add_circle,
                            ),
                            const SizedBox(width: 8),
                            TextConstant.subTile1(context,
                                text: controller.restaurantView.value.restaurantId != null
                                    ? 'Cập nhật'
                                    : 'Tạo mới',
                                color: Colors.white),
                          ],
                        )),
                  )
                ],
              ),
            ),
          ],
        ));
  }

  Widget _buildFormField(
    BuildContext context,
    String label,
    IconData icon,
    TextEditingController controller,
    String hintText,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: ColorsManager.primary, size: 18),
            const SizedBox(width: 8),
            TextConstant.subTile3(context, text: label, fontWeight: FontWeight.bold),
          ],
        ),
        const SizedBox(height: 8),
        FormFieldWidget(
          radiusBorder: 15,
          focusColor: ColorsManager.primary,
          borderColor: Colors.grey.shade300,
          padding: 20,
          setValueFunc: (v) {},
          controllerEditting: controller,
          labelText: hintText,
        ),
      ],
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: TextConstant.subTile1(context, text: 'Xác nhận xóa'),
          content: TextConstant.content(context, 
            text: 'Bạn có chắc chắn muốn xóa nhà hàng này không?'),
          actions: [
            TextButton(
              child: TextConstant.content(context, text: 'Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: TextConstant.content(context, 
                text: 'Xóa', 
                color: Colors.red),
              onPressed: () {
                // TODO: Implement delete restaurant
                Navigator.of(context).pop();
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }
}