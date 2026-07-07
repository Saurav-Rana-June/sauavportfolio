import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:saurav_portfolio/data/enums/snackbar_enum.dart';
import 'package:saurav_portfolio/data/services/portfolio_service.dart';
import 'package:saurav_portfolio/data/utils/app_utils.dart';

class ContactController extends GetxController {
  final log = Logger();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  RxBool isSubmitting = false.obs;

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    messageController.dispose();
    super.onClose();
  }

  Future<void> submitForm() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
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
      log.e('submitForm failed: $error');
      AppUtils.snackbar('Failed!', error.toString(), SnackBarType.error);
    } finally {
      isSubmitting.value = false;
    }
  }
}
