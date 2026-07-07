import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saurav_portfolio/data/enums/snackbar_enum.dart';
import 'package:saurav_portfolio/infrastructure/theme/colors.dart';

class AppUtils {
  static void snackbar(String title, String message, SnackBarType type) {
    Color backgroundColor;
    switch (type) {
      case SnackBarType.success:
        backgroundColor = AppColors.success;
      case SnackBarType.error:
        backgroundColor = AppColors.error;
      case SnackBarType.warning:
        backgroundColor = Colors.orange;
      case SnackBarType.info:
        backgroundColor = AppColors.primary;
    }

    Get.snackbar(
      title,
      message,
      backgroundColor: backgroundColor,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }
}
