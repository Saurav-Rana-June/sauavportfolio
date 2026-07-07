import 'package:get/get.dart';
import 'package:saurav_portfolio/data/models/portfolio/profile.model.dart';

class GlobalController extends GetxController {
  Rx<ProfileModel?> profile = Rx<ProfileModel?>(null);
  RxBool isInitialized = false.obs;

  void setProfile(ProfileModel value) {
    profile.value = value;
    isInitialized.value = true;
  }
}
