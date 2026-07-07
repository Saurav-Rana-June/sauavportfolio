import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:saurav_portfolio/data/enums/snackbar_enum.dart';
import 'package:saurav_portfolio/data/models/portfolio/project.model.dart';
import 'package:saurav_portfolio/data/services/portfolio_service.dart';
import 'package:saurav_portfolio/data/utils/app_utils.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ProjectDetailController extends GetxController {
  final log = Logger();

  RxBool isLoading = true.obs;
  Rx<ProjectModel?> project = Rx<ProjectModel?>(null);

  @override
  void onInit() {
    super.onInit();
    loadProject();
  }

  Future<void> loadProject() async {
    isLoading.value = true;
    try {
      final args = Get.arguments as Map<String, dynamic>?;
      final id = args?['id']?.toString();
      if (id == null || id.isEmpty) {
        AppUtils.snackbar('Error', 'Project not found.', SnackBarType.error);
        Get.back();
        return;
      }
      project.value = await PortfolioService.fetchProjectById(id);
      if (project.value == null) {
        AppUtils.snackbar('Error', 'Project not found.', SnackBarType.error);
        Get.back();
      }
    } catch (error) {
      log.e('loadProject failed: $error');
      AppUtils.snackbar('Failed!', error.toString(), SnackBarType.error);
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
