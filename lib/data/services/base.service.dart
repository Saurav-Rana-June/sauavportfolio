import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:saurav_portfolio/data/enums/snackbar_enum.dart';
import 'package:saurav_portfolio/data/methods/session_cleanup.dart';
import 'package:saurav_portfolio/data/utils/app_utils.dart';
import 'package:saurav_portfolio/infrastructure/navigation/routes.dart';

class BaseService {
  static final Logger _log = Logger();

  static void handleUnauthorized(DioException error) {
    if (error.response?.statusCode == 401) {
      _log.w('Unauthorized response received. Clearing session.');
      SessionCleanup.clearSession();
      Get.offAllNamed(Routes.landing);
      AppUtils.snackbar('Session expired', 'Please try again.', SnackBarType.warning);
    }
  }

  static String extractErrorMessage(DioException error) {
    final data = error.response?.data;
    if (data is Map && data['message'] != null) {
      return data['message'].toString();
    }
    return error.message ?? 'Something went wrong';
  }
}
