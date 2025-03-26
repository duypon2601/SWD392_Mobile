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
                    ? 'Chi tiết nhân viên'
                    : "Tạo mới nhân viên",
                fontWeight: FontWeight.w500,
                color: Colors.white),
          ),
          centerTitle: true,
          actions: [
            controller.employeeView.value.userId != null
                ? GestureDetector(
                    onTap: () {
                      // Show confirmation dialog before deleting
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            title: TextConstant.subTile1(context, 
                              text: 'Xác nhận xóa',
                              color: ColorsManager.primary
                            ),
                            content: TextConstant.content(context, 
                              text: 'Bạn có chắc chắn muốn xóa nhân viên này?'
                            ),
                            actions: [
                              TextButton(
                                child: TextConstant.content(context, 
                                  text: 'Hủy', 
                                  color: Colors.grey
                                ),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                              TextButton(
                                child: TextConstant.content(context, 
                                  text: 'Xóa', 
                                  color: Colors.red
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  controller.deleteUser();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.delete_outline,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          TextConstant.content(context, 
                            text: 'Xóa', 
                            color: Colors.white
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox()
          ],
        ),
        body: Stack(
          children: [
            Align(
                alignment: Alignment.bottomCenter,
                child: Opacity(
                  opacity: 0.8,
                  child: Image.asset('assets/moon.png')
                )),
            SingleChildScrollView(
              padding: EdgeInsets.all(UtilsReponsive.height(20, context)),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: EdgeInsets.all(UtilsReponsive.height(16, context)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: UtilsReponsive.height(40, context),
                              backgroundColor: ColorsManager.primary.withOpacity(0.1),
                              child: Image.asset(
                                'assets/user.png',
                                height: UtilsReponsive.height(50, context),
                                width: UtilsReponsive.height(50, context),
                              ),
                            ),
                            SizedBoxConst.size(context: context),
                            Obx(
                              () => TextConstant.titleH3(context,
                                text: controller.employeeView.value.userId != null
                                    ? 'Thông tin chi tiết'
                                    : "Thêm nhân viên mới",
                                color: ColorsManager.primary),
                            ),
                          ],
                        ),
                      ),
                      SizedBoxConst.size(context: context, size: 20),
                      _buildFormField(
                        context: context,
                        label: 'Họ và tên',
                        controller: controller.nameController,
                        icon: Icons.person,
                      ),
                      SizedBoxConst.size(context: context),
                      _buildFormField(
                        context: context,
                        label: 'Email',
                        controller: controller.emailController,
                        icon: Icons.email,
                      ),
                      SizedBoxConst.size(context: context),
                      _buildFormField(
                        context: context,
                        label: 'Tên đăng nhập',
                        controller: controller.usernameController,
                        icon: Icons.account_circle,
                        isEnabled: controller.employeeView.value.userId == null,
                        fillColor: controller.employeeView.value.userId == null
                            ? Colors.white
                            : Colors.grey.shade300,
                      ),
                      SizedBoxConst.size(context: context),
                      Visibility(
                          visible: controller.employeeView.value.userId == null,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFormField(
                                context: context,
                                label: 'Mật khẩu',
                                controller: controller.passController,
                                icon: Icons.lock,
                                isObscure: true,
                              ),
                              SizedBoxConst.size(context: context),
                            ],
                          )),
                      Row(
                        children: [
                          Icon(
                            Icons.work_outline, 
                            color: ColorsManager.primary,
                            size: 18,
                          ),
                          SizedBoxConst.sizeWith(context: context, size: 8),
                          TextConstant.subTile3(context, text: 'Chức vụ'),
                        ],
                      ),
                      SizedBoxConst.size(context: context, size: 8),
                      Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: ColorsManager.primary,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: const Offset(0, 1),
                              )
                            ],
                          ),
                          child: DropdownExample(
                              status:
                                  controller.employeeView.value.role ?? 'STAFF')),
                      SizedBoxConst.size(context: context, size: 24),
                      Center(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorsManager.primary,
                              padding: EdgeInsets.symmetric(
                                horizontal: UtilsReponsive.width(30, context),
                                vertical: UtilsReponsive.height(12, context),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: () {
                              controller.onTapAction();
                            },
                            child: Obx(() => controller.isLoading.value 
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                )
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      controller.employeeView.value.userId != null 
                                          ? Icons.save_outlined 
                                          : Icons.add_circle_outline,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    TextConstant.subTile1(context,
                                      text: controller.employeeView.value.userId != null 
                                          ? 'Cập nhật' 
                                          : 'Tạo mới',
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                            )),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  Widget _buildFormField({
    required BuildContext context,
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool isEnabled = true,
    Color? fillColor,
    bool isObscure = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon, 
              color: ColorsManager.primary,
              size: 18,
            ),
            SizedBoxConst.sizeWith(context: context, size: 8),
            TextConstant.subTile3(context, text: label),
          ],
        ),
        SizedBoxConst.size(context: context, size: 8),
        FormFieldWidget(
          radiusBorder: 15,
          padding: 20,
          borderColor: Colors.grey,
          focusColor: ColorsManager.primary,
          setValueFunc: (v) {},
          isEnabled: isEnabled,
          fillColor: fillColor,
          controllerEditting: controller,
          isObscureText: isObscure,
          suffixIcon: isObscure 
              ? GestureDetector(
                  onTap: () {
                    // For password toggle visibility if needed
                  },
                  child: const Icon(Icons.visibility_off, color: Colors.grey),
                )
              : null,
        ),
      ],
    );
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
      iconEnabledColor: Colors.white,
      dropdownColor: ColorsManager.primary,
      value: widget.status,
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
      isExpanded: true,
      underline: Container(height: 0),
      icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
    );
  }
}
