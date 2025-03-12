import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/employee_detail_controller.dart';

class EmployeeDetailView extends GetView<EmployeeDetailController> {
  const EmployeeDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EmployeeDetailView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'EmployeeDetailView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
