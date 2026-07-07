import 'package:get/get.dart';
import 'package:saurav_portfolio/presentation/landing/controllers/landing.controller.dart';

class LandingControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LandingController>(() => LandingController());
  }
}
