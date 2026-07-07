import 'package:get/get.dart';
import 'package:saurav_portfolio/presentation/project_detail/controllers/project_detail.controller.dart';

class ProjectDetailControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProjectDetailController>(() => ProjectDetailController());
  }
}
