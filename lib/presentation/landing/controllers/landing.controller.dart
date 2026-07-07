import 'package:get/get.dart';
import 'package:saurav_portfolio/data/methods/app_method.dart';
import 'package:saurav_portfolio/infrastructure/navigation/routes.dart';

class LandingController extends GetxController {
  RxBool isNavigating = false.obs;

  Future<void> enterPortfolio() async {
    if (isNavigating.value) return;
    isNavigating.value = true;
    await AppMethod.setHasVisited(true);
    await Get.offAllNamed(Routes.home);
    isNavigating.value = false;
  }
}
