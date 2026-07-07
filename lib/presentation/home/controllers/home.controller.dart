import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:saurav_portfolio/controllers/global.controller.dart';
import 'package:saurav_portfolio/data/enums/snackbar_enum.dart';
import 'package:saurav_portfolio/data/models/portfolio/project.model.dart';
import 'package:saurav_portfolio/data/services/portfolio_service.dart';
import 'package:saurav_portfolio/data/utils/app_utils.dart';
import 'package:saurav_portfolio/infrastructure/navigation/routes.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HomeController extends GetxController {
  final log = Logger();
  final globalController = Get.find<GlobalController>();

  RxBool isLoading = true.obs;
  RxList<ProjectModel> featuredProjects = <ProjectModel>[].obs;

  final ScrollController scrollController = ScrollController();
  final GlobalKey aboutSectionKey = GlobalKey();
  final GlobalKey skillsSectionKey = GlobalKey();
  final GlobalKey projectsSectionKey = GlobalKey();

  @override
  void onInit() {
    super.onInit();
    loadHomeData();
  }

  @override
  void onClose() {
    final scroll = scrollController;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scroll.dispose();
    });
    super.onClose();
  }

  Future<void> loadHomeData() async {
    isLoading.value = true;
    try {
      final profile = await PortfolioService.fetchProfile();
      final projects = await PortfolioService.fetchProjects();
      globalController.setProfile(profile);
      featuredProjects.assignAll(projects.take(3).toList());
    } catch (error) {
      log.e('loadHomeData failed: $error');
      AppUtils.snackbar('Failed!', error.toString(), SnackBarType.error);
    } finally {
      isLoading.value = false;
    }
  }

  void navigateToProjects() {
    Get.toNamed(Routes.projects);
  }

  void navigateToContact() {
    Get.toNamed(Routes.contact);
  }

  void openProjectDetail(ProjectModel project) {
    Get.toNamed(Routes.projectDetail, arguments: {'id': project.id});
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

  void scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context == null) return;
    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
}
