import 'package:get/get.dart';
import 'package:saurav_portfolio/presentation/project_details/controllers/project_details.controller.dart';

class ProjectDetailsControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProjectDetailsController>(() => ProjectDetailsController());
  }
}
