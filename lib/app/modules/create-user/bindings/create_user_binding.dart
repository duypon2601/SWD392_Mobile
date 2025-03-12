import 'package:get/get.dart';
import 'package:hotpot/app/model/user_data.dart';

import '../controllers/create_user_controller.dart';

class CreateUserBinding extends Bindings {
  @override
  void dependencies() {
    UserData emp = Get.arguments as UserData;
    Get.lazyPut<CreateUserController>(
      () => CreateUserController(employee: emp),
    );
  }
}
