import 'package:get/get.dart';
import 'package:todo_flutter/controllers/todo_controller.dart';

class TodoBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TodoController(), fenix: true);
  }
}
