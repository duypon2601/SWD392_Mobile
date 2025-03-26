import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotpot/resources/color_manager.dart';
import 'package:hotpot/resources/form_field_widget.dart';
import 'package:hotpot/resources/reponsive_utils.dart';
import 'package:hotpot/resources/text_style.dart';
import 'package:hotpot/resources/util_common.dart';

import '../controllers/create_user_controller.dart';

class CreateUserView extends GetView<CreateUserController> {
  const CreateUserView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorsManager.primary,
          title: Obx(
            () => TextConstant.titleH2(context,
                text: controller.employeeView.value.userId != null
                    ? 'Chi tiết'
                    : "Tạo mới",
                fontWeight: FontWeight.w500,
                color: Colors.white),
          ),
          centerTitle: true,
          actions: [
            controller.employeeView.value.userId != null
                ? GestureDetector(
                    onTap: () {
                      controller.deleteUser();
                    },
                    child: const Icon(
                      Icons.remove_circle_outlined,
                      color: Colors.white,
                    ),
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
                    controllerEditting: controller.emailController,
                  ),
                  SizedBoxConst.size(context: context),
                  TextConstant.subTile3(context, text: 'User name'),
                  FormFieldWidget(
                    radiusBorder: 15,
                    padding: 20,
                    borderColor: Colors.grey,
                    focusColor: ColorsManager.primary,
                    setValueFunc: (v) {},
                    fillColor: controller.employeeView.value.userId == null
                        ? Colors.white
                        : Colors.grey.shade300,
                    isEnabled: controller.employeeView.value.userId == null,
                    controllerEditting: controller.usernameController,
                  ),
                  SizedBoxConst.size(context: context),
                  Visibility(
                      visible: controller.employeeView.value.userId == null,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextConstant.subTile3(context, text: 'Password'),
                          FormFieldWidget(
                            radiusBorder: 15,
                            padding: 20,
                            isObscureText: true,
                            borderColor: Colors.grey,
                            focusColor: ColorsManager.primary,
                            setValueFunc: (v) {},
                            controllerEditting: controller.passController,
                          ),
                          SizedBoxConst.size(context: context),
                        ],
                      )),
                  TextConstant.subTile3(context, text: 'Chức vụ'),
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: UtilCommon.shadowBox(context,
                          colorBg: ColorsManager.primary),
                      child: DropdownExample(
                          status:
                              controller.employeeView.value.role ?? 'STAFF')),
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

class DropdownExample extends StatefulWidget {
  DropdownExample({super.key, required this.status});
  String status;

  @override
  State<DropdownExample> createState() => _DropdownExampleState();
}

class _DropdownExampleState extends State<DropdownExample> {
  final List<String> items = [
    'STAFF',
    'MANAGER',
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      iconEnabledColor: ColorsManager.primary,
      dropdownColor: ColorsManager.primary,
      value: widget.status, // Giá trị hiệnDropdownExample tại
      hint: const Text('Chọn'),

      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child:
              TextConstant.subTile3(context, text: value, color: Colors.white),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          if (newValue != null) {
            Get.find<CreateUserController>().employeeView.value.role = newValue;
            widget.status = newValue;
          }
        });
      },
      isExpanded: true, // Để dropdown mở rộng toàn bộ chiều ngang
      underline: Container(height: 2, color: Colors.blue), // Đường gạch dưới
      icon: const Icon(Icons.arrow_drop_down), // Icon thả xuống
    );
  }
}
