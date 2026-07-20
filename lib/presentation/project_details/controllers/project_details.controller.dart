import 'package:get/get.dart';
import 'package:saurav_portfolio/data/enums/snackbar_enum.dart';
import 'package:saurav_portfolio/data/models/portfolio/project.model.dart';
import 'package:saurav_portfolio/data/services/portfolio_service.dart';
import 'package:saurav_portfolio/data/utils/app_utils.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ProjectDetailsController extends GetxController {
  final Rxn<ProjectModel> project = Rxn<ProjectModel>();
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadProject();
  }

  Future<void> loadProject() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      if (Get.arguments is ProjectModel) {
        project.value = Get.arguments as ProjectModel;
        return;
      }

      final String? id = Get.parameters['id'];
      if (id == null || id.isEmpty) {
        errorMessage.value = 'No project ID specified.';
        return;
      }

      final loadedProject = await PortfolioService.fetchProjectById(id);
      if (loadedProject != null) {
        project.value = loadedProject;
      } else {
        errorMessage.value = 'Project not found.';
      }
    } catch (e) {
      errorMessage.value = 'Failed to load project details: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> openExternalLink(String? url) async {
    if (url == null || url.isEmpty || url == '#') {
      AppUtils.snackbar('Coming soon', 'Link will be available shortly.', SnackBarType.info);
      return;
    }
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url, mode: LaunchMode.externalApplication);
    }
  }
}
