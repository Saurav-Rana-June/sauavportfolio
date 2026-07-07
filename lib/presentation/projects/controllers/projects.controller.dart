import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:saurav_portfolio/data/enums/snackbar_enum.dart';
import 'package:saurav_portfolio/data/models/portfolio/project.model.dart';
import 'package:saurav_portfolio/data/services/portfolio_service.dart';
import 'package:saurav_portfolio/data/utils/app_utils.dart';
import 'package:saurav_portfolio/infrastructure/navigation/routes.dart';

class ProjectsController extends GetxController {
  final log = Logger();

  RxBool isLoading = true.obs;
  RxList<ProjectModel> allProjects = <ProjectModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadProjects();
  }

  Future<void> loadProjects() async {
    isLoading.value = true;
    try {
      final projects = await PortfolioService.fetchProjects();
      allProjects.assignAll(projects);
    } catch (error) {
      log.e('loadProjects failed: $error');
      AppUtils.snackbar('Failed!', error.toString(), SnackBarType.error);
    } finally {
      isLoading.value = false;
    }
  }

  void openProjectDetail(ProjectModel project) {
    Get.toNamed(Routes.projectDetail, arguments: {'id': project.id});
  }
}
