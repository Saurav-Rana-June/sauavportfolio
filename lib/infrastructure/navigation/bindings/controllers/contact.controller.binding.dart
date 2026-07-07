import 'package:get/get.dart';
import 'package:saurav_portfolio/presentation/contact/controllers/contact.controller.dart';

class ContactControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContactController>(() => ContactController());
  }
}
