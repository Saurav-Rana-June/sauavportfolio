import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:saurav_portfolio/controllers/global.controller.dart';
import 'package:saurav_portfolio/data/enums/snackbar_enum.dart';
import 'package:saurav_portfolio/data/models/portfolio/project.model.dart';
import 'package:saurav_portfolio/data/services/portfolio_service.dart';
import 'package:saurav_portfolio/data/utils/app_utils.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HomeController extends GetxController {
  final log = Logger();
  final globalController = Get.find<GlobalController>();

  RxBool isLoading = true.obs;
  RxBool isSubmitting = false.obs;
  RxList<ProjectModel> projects = <ProjectModel>[].obs;

  final ScrollController scrollController = ScrollController();
  final GlobalKey aboutSectionKey = GlobalKey();
  final GlobalKey skillsSectionKey = GlobalKey();
  final GlobalKey projectsSectionKey = GlobalKey();
  final GlobalKey contactSectionKey = GlobalKey();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  final GlobalKey<FormState> contactFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    loadHomeData();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    messageController.dispose();

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
      final allProjects = await PortfolioService.fetchProjects();
      globalController.setProfile(profile);
      projects.assignAll(allProjects);
    } catch (error) {
      log.e('loadHomeData failed: $error');
      AppUtils.snackbar('Failed!', error.toString(), SnackBarType.error);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitContactForm() async {
    if (!(contactFormKey.currentState?.validate() ?? false)) return;
    if (isSubmitting.value) return;

    isSubmitting.value = true;
    try {
      final success = await PortfolioService.submitContactForm(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        message: messageController.text.trim(),
      );
      if (success) {
        AppUtils.snackbar('Success', 'Message sent successfully!', SnackBarType.success);
        nameController.clear();
        emailController.clear();
        messageController.clear();
      } else {
        AppUtils.snackbar('Failed', 'Could not send message.', SnackBarType.error);
      }
    } catch (error) {
      log.e('submitContactForm failed: $error');
      AppUtils.snackbar('Failed!', error.toString(), SnackBarType.error);
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> openProject(ProjectModel project) async {
    final url = project.liveUrl ?? project.githubUrl;
    await openExternalLink(url);
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

  void scrollToTop() {
    if (!scrollController.hasClients) return;
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
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
